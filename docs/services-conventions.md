
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

When working with times (records in DB, logs, current time, etc.)...

1. Forbid reading time from DBMS functions, sequences, etc.

   In most cases the time is mocked in auto-tests written in programming languages, but not in any DBMS.
   So only auto-tests' code should calculate dates and times. Examples:
    * All date and time fields any database's table must be `NOT NULL`,
      the fields' default values must be set in testing code.
    * Queries like `... created_at < NOW() - INTERVAL ...` must be rewritten in the form like `... created_at < ?`,
      i. e. any date or time related value must be binded as a parameter value set in testing code.
1. Time zones must be considered.
    1. Services' time zone must be set to UTC. All data must be kept in UTC (+00:00).

       Use `Etc/UTC` or just `UTC` time zone identifier.
    1. Apply different time zones depending on contexts:
        1. If data is geographically bound to a time zone, store time in databases with the region-related time zone
           applied.

           Examples: aircraft landing in a particular airport, a package is delivered to a client located in
           a particular city, a sun rise in a particular region.
        1. Otherwise, store time in UTC in key services. Then apply a user-related local time zone correction,
           when formatting data in an interface service.

           Examples: an article is created, a user is updated.
