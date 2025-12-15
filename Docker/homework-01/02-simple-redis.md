# Zadanie `02-simple-redis`

## Cel

Postawmy `redis` dla `worker`. Na początek, zróbmy to "prymitywnie" (komunikacja przez hosta).

Celem zadania jest napisać skrypt, który:

1. ściągnie zadaną wersję obrazu `docker.io/library/redis`
1. zbuduje obraz `localhost/isa_worker:0.1.0-dev`
1. odpali `redis`, z wystawionym portem `6379:6379` na hoście
1. odpali `isa_worker` na podstawie `localhost/isa_worker:0.1.0-dev`  (z `REDIS_DISABLED=0`, lub w ogóle bez tej zmiennej)
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. ustawi sekundy na `2137` poprzez REST API
1. poczeka `5` sekund
1. wypisze logi z kontenerów
1. zastopuje kontenery

Oczywiście obraz musi budować się poprawnie, a `worker` musi działać :)

## Wskazówki

1. `REDIS_HOST` musi zostać ustawiony odpowiednio (np `127.0.0.1`).
1. Developerzy jak sami stawiają redis'a lokalnie, korzystają z polecenia `redis-server --appendonly yes`. Przy stawianiu kontenera `redis`, przekaż te parametry jako `CMD`.

### Przydatne polecenia

1. `docker image pull`
1. `docker container run`
    1. `--name`
    1. `-it`
    1. `--expose`
1. `docker container logs`
    1. `--follow`
