# Zadanie `03-network-connect`

## Cel

W zadaniu [`02-simple-redis.md`](./02-simple-redis.md) postawiliśmy redis'a, ale zrobiliśmy to nie według sztuki. Wystawianie (exposing) portów kontenerów do hosta ma dwa zastosowania:

1. Debug podczas development'u
1. Endpoint'y dla edge kontenerów (np reverse-proxy takie jak [`nginx`](https://nginx.org/))

W tych zastosowaniach (szczególnie w scenariuszu "na produkcję") nie mieści się "komunikacja aplikacja <-> baza danych".

Dlatego w tym zadaniu, zrobimy to "według sztuki", wykorzystując dedykowaną sieć.

Celem zadania jest napisać skrypt, który:

1. ściągnie zadaną wersję obrazu `docker.io/library/redis`
1. zbuduje obraz `localhost/isa_worker:0.1.0-dev`
1. utworzy sieć `isa_backend`
1. odpali `redis`
1. odpali `isa_worker` na podstawie `localhost/isa_worker:0.1.0-dev`  (z `REDIS_DISABLED=0`, lub w ogóle bez tej zmiennej)
1. podłączy oba kontenery do sieci (albo zrobi to w momencie ich tworzenia)
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. ustawi sekundy na `2137` poprzez REST API
1. poczeka `5` sekund
1. wypisze logi z kontenerów
1. zastopuje kontenery
1. usunie sieć `isa_backend`

Oczywiście obraz musi budować się poprawnie, a `worker` musi działać :)

## Wskazówki

1. `REDIS_HOST` musi zostać ustawiony odpowiednio (tym razem nie na `127.0.0.1`). Najlepiej skorzystaj z jakiegoś "dns" w docker network (domyślnie ID kontenera i jego nazwa, można się pokusić też o alias).
1. Można użyć `--internal` do sieci `isa_backend`, tak, żeby `redis` był wyizolowany.

### Przydatne polecenia

1. `docker network create`
    1. `--internal`
1. `docker network connect`
1. `docker container run`
    1. `--network`
    1. `--network-alias`
1. `docker network rm`
