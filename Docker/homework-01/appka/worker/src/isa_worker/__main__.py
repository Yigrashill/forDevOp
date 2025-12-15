from os import environ

from uvicorn import run

from isa_worker.app import app  # noqa: F401

if __name__ == "__main__":

    def int_from_env(key: str, default: int) -> int:
        try:
            ret = int(environ[key])
            return ret
        except (KeyError, ValueError):
            return default

    run(
        "isa_worker.app:app",
        host=environ.get("HOST", "0.0.0.0"),
        port=int_from_env("PORT", 8000),
        workers=int_from_env("WORKERS", 1),
        log_level="info",
    )
