# Zadanie `04-persist-data`

## Cel

Do tej pory stawiany redis nie zachowuje danych pomiędzy tworzeniem i kasowaniem kontenerów. Zmieńmy to. Interesuje nas zachowanie danych, które kontener `redis` zapisuje wewnętrznie do ścieżki `/data`.

Celem zadania jest napisać skrypt, który:

1. ściągnie zadaną wersję obrazu `docker.io/library/redis`
1. zbuduje obraz `localhost/isa_worker:0.1.0-dev`
1. utworzy sieć `isa_backend`
1. odpali `redis`
1. odpali `isa_worker` na podstawie `localhost/isa_worker:0.1.0-dev`  (z `REDIS_DISABLED=0`, lub w ogóle bez tej zmiennej), tak by zachowywać dane w `/data` pomiędzy uruchomieniami
1. podłączy oba kontenery do sieci (albo zrobi to w momencie ich tworzenia)
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. ustawi sekundy na `2137` poprzez REST API
1. poczeka `5` sekund
1. wypisze logi z kontenerów
1. zastopuje kontenery
1. wystartuje kontenery raz jeszcze
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. usunie sieć `isa_backend`

Po zastopowaniu kontenerów i ponownym ich odpaleniu, powinniśmy zaobserwować, że sekundy nie są liczone od zera, tylko od wartości sprzed zastopowania.

Oczywiście obraz musi budować się poprawnie, a `worker` musi działać :)

## Wskazówki

Skorzystaj z [docker volume](https://docs.docker.com/engine/storage/volumes/#create-and-manage-volumes).
Istnieją też [bind mount](https://docs.docker.com/engine/storage/bind-mounts/), ale on służą raczej do podłączania kodu źródłowego / plików konfiguracyjnych podczas development'u, niż storage dla baz danych (tylko dla zaawansowanych technik przy niektórych systemach plików).

### Przydatne polecenia

1. `docker volume create`
1. `docker volume rm`
1. `docker container run`
    1. `--volume` [[1]](https://docs.docker.com/engine/storage/volumes/#options-for---volume)
    1. `--mount` [[2]](https://docs.docker.com/engine/storage/volumes/#options-for---mount)
