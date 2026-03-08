---
title: "Flapjax vs Tangle"
date: 2011-12-06
slug: flapjax-vs-tangle
tags: [javascript, frp, programming]
draft: false
original_url: https://propella.blogspot.com/2011/12/flapjax-vs-tangle.html
---

This article examines Functional Reactive Programming (FRP) by comparing two JavaScript libraries: Flapjax and Tangle. "FRP is a framework to deal with time-varying data in a clean way," combining functional programming's elegance with object-oriented dynamics.

## Tangle's Approach

- Uses imperative programming with side effects
- Implements initialize-update structure
- Provides UI widgets like draggable number inputs
- Data flow managed through direct assignments

## Flapjax's Approach

- Eliminates side effects through the framework
- Represents time-varying data as behaviors (dependent trees)
- Lacks built-in widgets but offers better composability
- Converts behaviors through functional composition

## Practical Examples

The article demonstrates a calorie calculator where modifying cookie quantities automatically updates calorie consumption. Tangle requires HTML attributes like `data-var` and `data-min`, while Flapjax uses JavaScript functions like `extractValueB()` and `liftB()`.

## Advanced Concepts

For complex interactions (drag-and-drop widgets), Flapjax introduces event streams and higher-order event streams — handling state machines through functional composition rather than imperative state management.

## Conclusion

While Flapjax offers superior composability for complex behaviors, it requires more verbose syntax. Flapjax's dedicated compiler syntax improves readability significantly.
