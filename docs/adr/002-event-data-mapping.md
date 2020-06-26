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

1. As original object
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

### option 1 As original object

* Good, because easy to implement
* Bad, because objects can change
* Bad because objects can  fail to serialize

Definitely no-go

### option 2 As json-like object

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]

Need to pick actual format: Standard containers (variation of option #4), java.Json, gson.Json, some other implementation.

### option 3 As json string, convert on the fly

[example | description | pointer to more information | ?] <!-- optional -->

* Good, because RN can return data that way
* Bad, because maybe a bit expensive
* Bad, because can cause troubles in sinks ('json in json' problem)

### option 4 Limit attachment options to HashMaps and Lists initially, and let user decide how to do the conversion

* Good since easy to support in the library
* Bad due to lack of type information for values (thats why JSON types and RN Maps exist)

### option 5 Extract conversion options to some transformer strategy

Not sure how to handle it in sinks, but if we agree that end format must be primitive data containers, we are good.

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* ? <!-- numbers of links can vary -->
