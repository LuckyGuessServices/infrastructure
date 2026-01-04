
# Conventions used in services

## Service types

The project consists of services of these types:
1. _Key_ services store and process data related to particular entities or domains.
   Example: storing a country-related working calendars that reflect public holidays and shorter working days.
2. _Interface_ services request various data from _key_ services, aggregate, format and deliver to an end user.
   Example: an SPA or a backend application with SSR that implements API clients to connect to services
   (both internal _key_ services or external APIs).
3. _Infrastructure_ services provide the basement (mostly, container-based) for the rest of services to operate.
   Examples: HTTP servers, database management systems, message brokers, etc.

## Date and time

1. When working with times (records in DB, logs, current time, etc.), a time zone must be considered.
    1. Services' time zone must be set to UTC. All data must be kept in UTC (+00:00).

       Use `Etc/UTC` or just `UTC` time zone identifier.
    1. Apply a time zone depending on a context:
        * If data is geographically bound to a time zone (aircraft landing in a particular airport, a package is
          delivered to a client located in a particular city, a sun rise in a particular region), store time in
          databases with the region-related time zone applied.
        * Otherwise (an article is created, a user is updated, etc.), store time in UTC 0 in key services. Then apply
          a user-related local time zone correction, when formatting data in an interface service.
