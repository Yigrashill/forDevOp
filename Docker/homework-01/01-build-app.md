
# Zadanie `01-build-app`

## Cel

Zbudujmy sobie [aplikację](./appka/) `worker`.

Celem zadania jest napisać skrypt, który:

1. zbuduje obraz `localhost/isa_worker:0.1.0-dev`
1. odpali na jego podstawie kontener o nazwie `isa_worker` (ze zmienną środowiskową czasu uruchomienia `REDIS_DISABLED=1`)
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. ustawi sekundy na `2137` poprzez REST API (jak to zrobić z poziomu hosta? `EXPOSE` / `--expose`)
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. zastopuje kontener

Oczywiście obraz musi budować się poprawnie, a `worker` musi działać :)

## Wskazówki

1. Developerzy korzystają w poniższy sposób ze skryptu [`uruchom.sh`](./appka/worker/uruchom.sh), by lokalnie wystartować `worker`

    ```shell
    (export REDIS_DISABLED=1 FLAVOUR=dev; ./uruchom.sh)
    ```

    jeśli nic się "nie wywali", używają `http://localhost:8000/docs` w przeglądarce i `curl` z terminala.

1. Developerzy korzystają z [`uv`](https://astral.sh/blog/uv) do zarządzania venv'ami[[1]](https://docs.python.org/3/library/venv.html) [[2]](https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/) i projektem. Program ten wykorzystuje [`pyproject.toml`](https://packaging.python.org/en/latest/specifications/pyproject-toml/) oraz `uv.lock`.
Jeśli to dla Ciebie za dużo, możesz skorzystać z pliku `requirements.txt` oraz programu [`pip`](https://pip.pypa.io/en/stable/cli/pip_install/) podczas budowania obrazu.

1. Czy warto, żeby wszystkie pliki wrzucać do kontenera? Przeczytaj o [`.dockerignore`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#dockerignore-file).

### Przydatne polecenia

1. `docker image build`
    1. `--tag`
1. `docker container run`
    1. `--name`
    1. `-it`
    1. `--env`
    1. `--expose`
1. `docker container logs`
    1. `--follow`
1. `apk add`
    1. `--no-cache`
1. `pip install`
    1. `-r`
1. `uv venv`
1. `uv sync`
    1. `--frozen`
    1. `--locked`
1. `uv export`

### Przydatne instrukcje w Dockerfile

1. [Ogólny overview](https://docs.docker.com/build/concepts/dockerfile/)
1. [Ogólnie o kontekście budowania](https://docs.docker.com/build/concepts/context/#local-directories)
1. [`# syntax=`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#syntax)
1. [`ARG`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#arg)
1. [`FROM`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#from)
1. [`SHELL`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#shell)
1. [`WORKDIR`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#workdir)
1. [`COPY`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#copy)
1. [`ENV`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#env)
1. [`RUN`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#run)
1. [`ENTRYPOINT`](https://github.com/moby/buildkit/blob/dockerfile/1.20.0/frontend/dockerfile/docs/reference.md#entrypoint)
