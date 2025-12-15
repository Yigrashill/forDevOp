import asyncio
import logging
from collections import defaultdict
from contextlib import asynccontextmanager
from http import HTTPStatus
from os import environ
from typing import Annotated, NoReturn, Self

import redis
from fastapi import FastAPI, HTTPException, Path
from fastapi.responses import JSONResponse


# TODO: move each class to its own separate file
# abstract class / interface for redis, could be moved to separate file
class BaseRedis:
    def __init__(
        self: Self,
        host: str,
        port: int,
    ) -> None:
        raise NotImplementedError

    def seconds_get(self: Self) -> int | None:
        raise NotImplementedError

    def seconds_set(self: Self) -> int | None:
        raise NotImplementedError

    async def endless_seconds(
        self,
        how_fast: int = 1,
    ) -> NoReturn:
        while True:
            await asyncio.sleep(1)
            try:
                seconds_passed = self.seconds_get()
            except Exception:
                pass
            else:
                logger.info(f"\tSeconds passed    \t: {seconds_passed}")

                self.seconds_set(seconds_passed + how_fast)


# TODO: move each class to its own separate file
# fake redis for dev/test used when no redis is available
class FakeRedis(BaseRedis):
    storage: defaultdict

    def __init__(
        self: Self,
        host: str,
        port: int,
    ) -> None:
        logger.info("Using fake redis.")
        self.storage = defaultdict()

    def seconds_get(self: Self) -> int | None:
        return self.storage.get("seconds", 0)

    def seconds_set(
        self: Self,
        seconds: int,
    ) -> None:
        self.storage["seconds"] = seconds


# TODO: move each class to its own separate file
# real redis client
class RealRedis(BaseRedis):
    _redis: redis.Redis

    def connect(
        self: Self,
        host: str,
        port: int,
    ) -> redis.Redis:
        try:
            logger.info(f"Connecting to redis at {host}:{port}...")
            r = redis.Redis(
                host=host,
                port=port,
                db=0,
            )
            r.ping()
        except Exception as e:
            logger.error(f"Failed to connect to redis, reason: {e}")
            raise e
        else:
            logger.info("Connected!")
            return r

    def __init__(
        self: Self,
        host: str,
        port: int,
    ) -> None:
        self._redis = self.connect(host, port)

    def seconds_get(self: Self) -> int | None:
        try:
            seconds_passed = int(self._redis.get("seconds") or 0)
        except Exception as e:
            logger.error(f"Failed to get seconds in redis, reason: {e}")
            raise e
        return seconds_passed

    def seconds_set(
        self: Self,
        seconds: int,
    ) -> None:
        try:
            self._redis.set("seconds", seconds)
        except Exception as e:
            logger.error(f"Failed to set seconds in redis, reason: {e}")
            raise e


# mainly so that IDE gives nice hints
type AnyRedis = FakeRedis | RealRedis


# choose whether to use fake or real redis based on value of env variable
def redis_real_or_fake() -> AnyRedis:
    match environ.get("REDIS_DISABLED", "false").lower():
        case "true" | "1":
            return FakeRedis
    return RealRedis


# APP and API setup


# this method is invoked just before app is started
# https://fastapi.tiangolo.com/advanced/events/#lifespan
@asynccontextmanager
async def lifespan(
    app: FastAPI,
):
    # global is an anti-pattern, using it here just for brevity
    global our_redis
    our_redis = redis_real_or_fake()(
        host=environ.get("REDIS_HOST", "127.0.0.1"),
        port=environ.get("REDIS_PORT", 6379),
    )
    # create background task
    asyncio.create_task(our_redis.endless_seconds())
    logger.info("lifespan: start")
    yield  # at this yield, app is actually started
    # after yield above, app has already stopped
    # do any cleanup steps here
    logger.info("lifespan: end")


# configure app logger
logger = logging.getLogger("uvicorn.error")

logger.info(f"Interpreting {__name__}: begin")

our_redis: AnyRedis
app = FastAPI(
    title="ISA Worker",
    lifespan=lifespan,
)


# TODO: move to separate files per API path
# API definitions


@app.get("/")
async def root() -> JSONResponse:
    return {
        "message": "Hello World",
    }


@app.get("/api/v1/seconds")
async def seconds_get() -> JSONResponse:
    try:
        return {
            "message": "success",
            "seconds": f"{our_redis.seconds_get()}",
        }
    except Exception:
        raise HTTPException(
            HTTPStatus.INTERNAL_SERVER_ERROR,
            "Something happened :<",
        )


@app.put("/api/v1/seconds/{seconds}")
async def seconds_put(
    seconds: Annotated[
        int,
        Path(
            description="Number of seconds to be set; must be non-negative.",
            ge=0,
        ),
    ],
) -> JSONResponse:
    logger.info(f"\tSetting seconds to\t: {seconds}")
    our_redis.seconds_set(seconds)
    return {
        "message": "success",
    }


logger.info(f"Interpreting {__name__}: end")
