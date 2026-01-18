
# TODO

- [MVP](#mvp)
- [Misc features](#misc-features)

## MVP

1. Create MVP for `planets` data service.
    * Create and API server with a couple of methods. Support at least one planet.
    * Utilize at least one external API.
    * Cover all developed logic with autotests (DB-supported).
1. Create MVP for `calendar`, working calendar data service.
   * Create and API server with a couple of methods. Support at least day types (weekend, short, holiday).
   * Utilize at least one external API.
   * Cover all developed logic with autotests (DB-supported).
1. Init a backend interface service `lug-backend`.
    * Add an API client for `planets` and `calendar` (support all currently existing methods).
    * Add console scripts acting as an interface (utilizing all currently existing methods).
    * Request all internal services' data via APIs in parallel during a single foreground script launch.

## Misc features

* Create an authorization service.
   Support normal and admin users, control the list of services a user can access. Init authorization via `lug-backend`.
   All other services must somehow analyze requests, if those are made by authorized users with proper access.
* Profiling (time and memory): autotests, queries to databases, external API responses, etc. ...,
  and (as "the rest") internal code execution.
* High load testing.
* "Mutations" autotests.
* Code static analyzers and code style fixers.
* Add a dedicated RAM database.
* User time zones support: apply time formatting depending on a user time zone (auto or manually specified).
* I18N (at least, `ru_RU` and `en_US`).
* Add a new service: weather data. Start with a single country. Or start with Luna phases.
