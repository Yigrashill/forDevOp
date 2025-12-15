# Aplikacja ISA

To przykładowa aplikacja na potrzeby labów z `docker` i `docker compose`.

Jest zrealizowana jako [monorepo](https://monorepo.tools/).

Składa się z:

1. `worker`, który wykonuje jakąś pracę.
    Dokładniejszy opis znajdziecie [tutaj](./worker/README.md).
1. [`redis`](https://redis.io/) jako baza danych (a dokładniej [key-value store](https://en.wikipedia.org/wiki/Key%E2%80%93value_database))
1. [`nginx`](https://nginx.org/) jako:
    1. web server[[1]](https://en.wikipedia.org/wiki/Comparison_of_web_server_software) [[2]](https://docs.nginx.com/nginx/admin-guide/web-server/web-server/)
    1. reverse proxy[[1]](https://en.wikipedia.org/wiki/Reverse_proxy) [[2]](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
    1. load balancer[[1]](https://en.wikipedia.org/wiki/Load_balancing_(computing)) [[2]](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) (na potrzeby labów z `docker` nie będziemy implementować load balancing'u).
