# Custom structured data mapping

* Status: proposed
* Deciders: Aleksandr Smirnov, Anton Kononenko, Alex Zchut, Ran Meirman
* Date: 2020-06-25

Technical Story: a way to map objects into structured data, like Maps, Lists, and JSON

## Context and Problem Statement

We have an option to attach objects to the log event:
* as part of the logger context
* as part of the Event data explicitly
* as part of the named template formatter arguments

As of now, any type of object can be attached, but not all sinks will be able to handle it properly.


## Decision Drivers

* We do not want to do heavy type conversion/serialization when its not required
* We want a convenient way to use this data in any sink
* Event data fields must be final (constant) POJO

## Considered Options

1. As original object (bad and risky: objects can change, fail to serialize, etc), definitely no-no
2. As json-like object (i.e. HashMaps and Lists, or some Json type), with conversion on the fly (maybe a bit expensive)
3. As json string, convert on the fly (still expensive for java. easy to obtain from RN and locally, but lacks flexibility, possibly problematic for some sinks ('json in json' problem))
4. Limit attachment options to HashMaps and Lists initially, and let user decide how to do the conversion
5. Extract conversion options to some transformer strategy

## Decision Outcome


### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, ?]
* ?

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, ?]
* ?

## Pros and Cons of the Options <!-- optional -->

### Additional data format:
* As original object (bad and risky: objects can change, fail to serialize, etc), definitely no-no
* As json-like object, convert on the fly (maybe a bit expensive)
* As json string, convert on the fly (still expensive for java. easy to obtain from RN and locally, but lacks flexibility, possibly problematic for some sinks ('json in json' problem))

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
