#!/bin/sh
set -eu
# cspell: disable-next-line
THIS_SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)

required='python uv uvicorn fastapi'
# shellcheck disable=SC2086
which ${required} || {
	echo "W PATH brakuje jednego z następujących programów:"
	printf '\t%s\n' ${required}

	printf \
		'%s\n\t%s\n' \
		"Zeby zainstalowac python, uzyj (gdziekolwiek):" \
		"sudo apt update && sudo apt install python3{,-pip}"
	printf \
		'%s\n\t%s\n\t%s\n' \
		"Zeby zainstalowac pipx, uzyj (gdziekolwiek):" \
		"sudo apt install pipx" \
		"sudo pipx ensurepath"
	printf '%s\n\t%s\n' \
		"Zeby zainstalowac uv, uzyj (gdziekolwiek):" \
		"pipx install uv"
	printf '%s\n\t%s\n' \
		"Zeby zainstalowac uvicorn i fastapi, uzyj (w '${THIS_SCRIPT_DIR}'):" \
		"uv venv && uv sync && source .venv/bin/activate"
	exit 1
}

set -x

# fastapi
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8000}"
WORKERS="${WORKERS:-1}" # zwieksz na 4 i zobacz co sie stanie!

# redis
REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"
export REDIS_HOST
export REDIS_PORT

case "${FLAVOUR}" in
"dev")
	# z pominieciem __main__.py
	uv run fastapi dev \
		--host="${HOST}" \
		--port="${PORT}" \
		--reload \
		./src/isa_worker/app.py \
		;
	;;
"prod")
	(
		cd ./src
		python -m isa_worker
	)
	;;
"")
	echo "Ups, jest mi smutno :C"
	;;
esac
