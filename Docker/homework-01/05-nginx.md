# Zadanie `05-nginx`

## Cel

Do tej pory używaliśmy `worker` "bezpośrednio". Współcześnie, rzadko kiedy wystawia się aplikacje webowe "tak o". Zazwyczaj, serwuje się je poprzez tzw [software'owe web servery](https://en.wikipedia.org/wiki/Comparison_of_web_server_software), takie jak:

- [Apache Tomcat](https://tomcat.apache.org/)
- [`nginx`](https://www.nginx.com/) / [`freenginx`](https://freenginx.org/)
- [`haproxy`](https://www.haproxy.org/)
- [`traefik`](https://traefik.io/traefik/)
- [`caddy`](https://caddyserver.com/)
- [`pingora`](https://github.com/cloudflare/pingora)

etc. (kolejność pseudolosowa od najstarszego do najnowszego).

Dlaczego? Załatwiają nam [powtarzalne i żmudne zadania](https://en.wikipedia.org/wiki/Web_server?lang=en#Common_tasks), bez których bardzo trudno byłoby serwować aplikacje "na internetach" w bezpieczny i wydajny sposób.

Bardzo często jeden taki web serwer obsługuje zdecydowanie więcej niż jedną aplikację. W naszym wypadku, będzie to jedna aplikacja.

Na potrzeby labów, skorzystamy ze sprawdzonego `nginx`a.

Celem zadania jest napisać skrypt, który:

1. ściągnie zadaną wersję obrazu `docker.io/library/redis`
1. zbuduje obraz `localhost/isa_worker:0.1.0-dev`
1. utworzy sieć `isa_backend`
    1. jako `internal`
    1. podpięte do niego `worker` i `redis`
1. utworzy sieć `isa_frontend`
    1. podpięte do niego `worker` i `nginx`
1. odpali `redis`
1. odpali `isa_worker` na podstawie `localhost/isa_worker:0.1.0-dev`  (z `REDIS_DISABLED=0`, lub w ogóle bez tej zmiennej), tak by zachowywać dane w `/data` pomiędzy uruchomieniami
1. odpali `nginx`
    1. tylko ten kontener będzie wystawiał porty
    1. powinny to być porty `80:80` i `443:443`, ale w przypadku konfliktów można wybrać np `7000:80` i `7443:443`
    1. w [`nginx.conf`](./appka/nginx/nginx.conf#L8), `nginx` spodziewa się hostname `worker`

        **SPOILER ALERT:** na labach z `compose`, będziemy faktycznie spodziewać się hostname `worker` z poziomu kontenera z `nginx`.

        Tutaj żeby to działało, albo zmodyfikuj odpowiednio `nginx.conf`, albo użyj odpowiedniej flagi przy przy tworzeniu `isa_worker` ([`network-connect.md`](./network-connect.md#przydatne-polecenia)).

1. podłączy oba kontenery do sieci (albo zrobi to w momencie ich tworzenia)
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. ustawi sekundy na `2137` poprzez REST API (przez `nginx`a, nie strzelając `curl`em bezpośrednio do `worker`a)
1. poczeka `5` sekund
1. wypisze logi z kontenerów
1. zastopuje kontenery
1. wystartuje kontenery raz jeszcze
1. poczeka `5` sekund
1. wypisze logi z kontenera
1. usunie sieci `isa_backend` i `isa_frontend`

Po zastopowaniu kontenerów i ponownym ich odpaleniu, powinniśmy zaobserwować, że sekundy nie są liczone od zera, tylko od wartości sprzed zastopowania.

W logach `nginx` powinniśmy zaobserwować przekazywanie ruchu.

Oczywiście obraz musi budować się poprawnie, a `worker` musi działać :)

## Wskazówki

1. Możesz skorzystać z konfiguracji `nginx` umieszczonej [tutaj](./appka/nginx/nginx.conf).
1. Jeśli hostname podany w konfiguracji `nginx` nie jest "rozwiązywalny" (resolve) w momencie działania `nginx`'a (bo np. kontener o danej nazwie jeszcze nie wstał / "wywalił się"), to cały `nginx` się "wywali".

### Przydatne polecenia

1. `nginx -t` do weryfikowania configu
1. `nginx -s reload` do przeładowywania configu
1. `docker exec ${nazwa_kontenera} sh -c 'nginx -t && nginx -s reload'`
