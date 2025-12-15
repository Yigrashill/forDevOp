# Aplikacja ISA - Worker

To jest aplikacja napisana w [pythonie3.13](https://docs.python.org/3/) korzystająca z framework'ów [uvicorn](https://www.uvicorn.org/) i [FastAPI](https://fastapi.tiangolo.com/).

Ma dwie główne funkcje.

1. Odlicza czas który upłynął od pierwszego startu, domyślnie inkrementuje co 1 sekundę (funkcja `endless_seconds`[[1]](./src/isa_worker/app.py#L30-L43)[[2]](./src/isa_worker/app.py#L148), parametr `how_fast`[[1]](./src/isa_worker/app.py#L32)). Co sekundę, czas ten jest podawany w logach aplikacji.

    ```log
    INFO   Application startup complete.
    INFO   Seconds passed    : 0
    INFO   Seconds passed    : 1
    INFO   Seconds passed    : 2
    INFO   Seconds passed    : 3
    INFO   Seconds passed    : 4
    ```

1. Wystawia REST API[[1]](https://en.wikipedia.org/wiki/REST) [[2]](https://devhints.io/rest-api), które umożliwia odczyt oraz modyfikację zapisanej wartości czasu z poprzedniego punktu.

    1. `curl -x GET ${URL}:${PORT}/` zwróci

        ```json
        {
            "message": "Hello World"
        }
        ```

    1. `curl -x GET ${URL}:${PORT}/api/v1/seconds` zwróci

        ```json
        {
            "message": "success",
            "seconds": "123",
        }
        ```

        gdzie zamiast `123` bedzie liczba sekund od pierwszego startu aplikacji

    1. `curl -x PUT ${URL}:${PORT}/api/v1/seconds/123` zwróci

        ```json
        {
            "message": "success"
        }
        ```

        a liczba sekund od pierwszego startu aplikacji zostanie zamieniona na `123` (lub inną podaną liczbę)

    Po starcie `worker`, możecie w przeglądarce wejść `${URL}:${PORT}/docs` by zobaczyć dokumentację serwowaną poprzez [SwaggerUI](https://swagger.io/tools/swagger-ui/) (lub `${URL}:${PORT}/redoc` dla [Redoc](https://github.com/Redocly/redoc)). Co ważniejsze, z poziomu tej dokumentacji możecie sobie "poklikać" te endpoint'y REST i zaobserwować, jak to wpływa na aplikację `worker` (przyciski "Try it out"). Po kliknięciu execute, dostaniecie też pełną formę `curl`a który był użyty do danego zapytania API.

Aplikacja jest zaprojektowana tak, że `worker` do działania potrzebuje jakiegoś [redis'a](https://redis.io/), dostępnego pod `${REDIS_HOST}:${REDIS_PORT}`. Jeśli nie będzie w stanie się podłączyć, to "wywali się".

Jeśli nie macie pod ręką (jeszcze) redis'a, możecie ustawić zmienną środowiskową `REDIS_DISABLE=1`. Wtedy `worker` zapisuje sekundy lokalnie (bez potrzeby łączenia się do redis'a).
