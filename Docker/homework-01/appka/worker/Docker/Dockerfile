
FROM python:3.13-slim
WORKDIR /app


RUN pip install --no-cache-dir uv


COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

COPY ./src ./src

EXPOSE 8000

CMD ["uv", "run", "fastapi", "dev", "--host=0.0.0.0", "--port=8000", "./src/isa_worker/app.py"]

