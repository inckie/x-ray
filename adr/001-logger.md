# Universal logger API

* Status: proposed
* Deciders: Aleksandr Smirnov, Anton Kononenko, Alex Zchut, Ran Meirman
* Date: 2020-06-25

Technical Story: issues with diagnostics tooling

## Context and Problem Statement
Right now we do not have any consolidated logging policies and tools.

It leads to a number of issues:
- Many errors are silently ignored even by developers, and lead to obscure effects
- Meaningful information, even if its logged, is not standardized
- QA does not use logging information
- Zapp users can't identify issues without developers help
- We can not diagnose problems on remote systems
- We cant run complex analysis on logging outputs we have now
- Potentially valuable information from logging is not attached to the bug reports


## Decision Drivers

**We do not want to write one more logging library. We want to write an umbrella library with convenient architecture to reuse existing tools and libraries.**

* We want easy and flexible syntax for developers
* We want to be able to use existing embedded and 3rd party logging solutions without changing the logging code: ADB, Apple Logging, Elastic
* We want to be able to provide as much information as possible for every logging output
* We want solution to be open source and not dependent on Applicaster SDKs
* We want solution ot be modular to allow:
  * easy integration of new external logging systems (such as Elastic, MS AppCenter, etc.)
  * easy integration with new platforms (such as ReactNative)
  * easy integration of context providers to enrich the data
* We want to be able to create user-facing UIs to interact with the logging
* We want the system to be easily configurable, both locally by developer, and remotely
  * hierarchy must be present, so we can configure logging output depth for every system
  * route filtering from logging point to every logging output
  * formatters should be interchangeable and configurable
* We want to build on top of the existing logging systems as close as possible


## Considered Options

* [option 1]
* [option 2]
* [option 3]
* ? <!-- numbers of options can vary -->

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | ? | comes out best (see below)].

![Diagram](./001-logger/logger_diagram.png)



### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, ?]
* ?

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, ?]
* ?

## Pros and Cons of the Options <!-- optional -->

### [option 1]

[example | description | pointer to more information | ?] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* ? <!-- numbers of pros and cons can vary -->

### [option 2]

[example | description | pointer to more information | ?] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* ? <!-- numbers of pros and cons can vary -->

### [option 3]

[example | description | pointer to more information | ?] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* ? <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* ? <!-- numbers of links can vary -->
