# Mapping events to sinks

* Status: proposed
* Deciders: Aleksandr Smirnov, Anton Kononenko, Alex Zchut, Ran Meirman
* Date: 2020-07-01

## Context and Problem Statement

We need an easy way to specify which event goes into which sinks.

## Decision Drivers

* Mapping should be implemented as a black box component independent from the other parts of the system. It should not tap into sinks, event builders, or loggers. Its interface describes the entire field sets that can be used for routing.
* In most cases we want to restrict the event from been logged, but be able to release this restriction where needed. An example is limiting output to the sink to a warn or error level for most of the events, but allowing debug events from particular subsystems to come through.
* We want to be able to avoid expensive event building calls if event will not be logged at all at the end (no mapped sinks).

## Considered Options

1. -
2. -

## Decision Outcome

File system-like approach:
* Each Subsystem name is represented by hierarchical path-like name, like "com.applicaster.someplugin/somemodule/someclass"
* There is an empty named root level
* For each sink, we can specify the filter at any level of virtual hierarchy.
* Default root level filter for any sink considered to be 'allowed'
* During mapping resolution, system looks for a closest filter in the hierarchy going upwards.
* First filter found is the only filter applied, i.e. it overrides filters set on the upper levels of the hierarchy
* Filter can implement any filtering logic, both releasing or tightening the restrictions.

### Positive Consequences

* Having single easily located point of filtering decision for every sink increases transparency and allows to avoid the need to provide complex and verbose boolean logic API inside the library. If needed, user can always implement it in custom filter class.
* Having it isolated allows to use sinks subsystem with filtering capability for other logging frameworks
* Due to a usage of the subset of the data fields only, and not a final event object, we can optimize the flow by omitting event building entirely when there is no sinks to send this event into.
* For the same reason, we can use other event building flows with all the benefits of both our routing and client-side features, i.e. run in inside JS, where complex format and object dumping is much easier and faster

### Negative Consequences

* List of data fields used for filtering/routing can grow in the future littering the interface. It can be later mitigated by using a data object with subset of event fields as a single argument to a filter, and providing an adapter for old filters.
