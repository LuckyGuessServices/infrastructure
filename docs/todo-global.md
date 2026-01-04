
# TODO

- [MVP](#mvp)
- [Misc features](#misc-features)

## MVP

1. Init a planets' data service `lug-planets`.
   Create and API server with a couple of methods. Support at least one planet, utilize at least one external API,
   cover all developed logic with autotests (DB-supported).
1. Init a backend interface service `lug-backend`.
   Add an API client for `lug-planets` (support all currently existing methods), add console scripts acting as
   a kind of an interface (utilizing all currently existing methods).
1. Init a working calendar service `lug-calendar`.
   Create and API server with a couple of methods (utilizing an external API is optional), cover all developed logic
   with autotests (DB-supported).
1. Make `lug-backend` request data from `lug-planets` and `lug-calendar` within a single foreground script launch.

## Misc features

* Create an authorization service.
   Support normal and admin users, control the list of services a user can access. Init authorization via `lug-backend`.
   All other services must somehow analyze requests, if those are made by authorized users with proper access.
* Profiling (time and memory): autotests, queries to databases, external API responses, etc. ...,
  and (as "the rest") internal code execution.
* High load testing.
* "Mutations" autotests.
* Code static analyzers and code style fixers.
* Replace HTTP server caching mechanism with a dedicated RAM database.
* User time zones support: apply time formatting depending on a user time zone (auto or manually specified).
* I18N (at least, `ru_RU` and `en_US`).
* New service: weather data. Start with a single country. Or start with Luna phases.
