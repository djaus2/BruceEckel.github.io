---
layout: post
published: true
title: Operator Underloading In Scala
---

Here's a place where Scala does some clever stuff which ultimately might produce a more complicated programming model than one would like. I discovered it while sorting out some issues with the first exercise in the *References & Mutability* atom in [Atomic Scala](http://www.atomicscala.com/).

I'll give you the examples directly out of the solution guide --- this includes the use of our tiny **AtomicScala** test framework, but if you don't want to include that you can just comment out the **import** and all the **is** statements and you'll still get the same results.

The default **Map** class is immutable. So if we try to change an existing element or add a new key-value pair, it won't let us, as expected:

```Scala
// Solution-1a.scala
// Solution to Exercise 1 in "References & Mutability"
import com.atomicscala.AtomicTest._

var m = Map("Foo" -> "Bar")

m("Goat") = "Calico" // Try to add a new pair

/* OUTPUT_SHOULD_CONTAIN
error: value update is not a member of scala.collection.immutable.Map[String,String]
m("Goat") = "Calico" // Try to add a new pair
^
one error found
*/
```

(The same error is produced when trying to change an existing element).

But now there is a surprise. The **+=** and **-=** operators, at first blush, appear to allow modification of **m**:

```Scala
// Solution-1c.scala
// Solution to Exercise 1 in "References & Mutability"
import com.atomicscala.AtomicTest._

var m = Map("Foo" -> "Bar")
val original = m
m is "Map(Foo -> Bar)"

// Surprise! The following appears to be modifying an existing
// immutable map! What's happening here?
m += ("Frog" -> "Green")
m += ("Cow" -> "Brown")
m is "Map(Foo -> Bar, Frog -> Green, Cow -> Brown)"
m -= "Cow"
m is "Map(Foo -> Bar, Frog -> Green)"

/* The '+' and '-' parts of '+=' and '-=' cause a new Map to be
   created, and the '=' part assigns that new map to m, which works
   because m is a var. Try changing it to a val and see what happens.
   But the original Map object is not modified, as you can see here:
*/
original is "Map(Foo -> Bar)"

/* OUTPUT_SHOULD_BE
Map(Foo -> Bar)
Map(Foo -> Bar, Frog -> Green, Cow -> Brown)
Map(Foo -> Bar, Frog -> Green)
Map(Foo -> Bar)
*/
```

Once we realize what's happening, it does kind of make sense. And **Map**'s immutability is not violated, while still allowing what we want to accomplish with the **+=** and **-=**.

When you start thinking this way, that the reason this works is because **m** is a **var**, it then makes sense to think that if you change **m** to a **val**, the above code should stop working. But we're in for another surprise:

```Scala
// Solution-1d.scala
// Solution to Exercise 1 in "References & Mutability"
import com.atomicscala.AtomicTest._
import collection.mutable.Map

val m = Map("Foo" -> "Bar")
val original = m
m is "Map(Foo -> Bar)"
m("Foo") = "Zup"
m is "Map(Foo -> Zup)"
m("Goat") = "Calico" // Adds a new pair
m is "Map(Goat -> Calico, Foo -> Zup)"

// From our logic in Solution-1c.scala, this SHOULDN'T work.
// But it does! NOW what's going on?
m += ("Frog" -> "Green")
m += ("Cow" -> "Brown")
m is "Map(Goat -> Calico, Foo -> Zup, Frog -> Green, Cow -> Brown)"
m -= "Cow"
m is "Map(Goat -> Calico, Foo -> Zup, Frog -> Green)"

/* In Solution-1c.scala, the += wasn't overloaded for the immutable Map,
   so Scala synthesized it by first applying '+' and then '='. But there
   IS a += defined for the mutable Map, so that is called in this case.
*/

// Note that here, the original IS being directly modified:
original is "Map(Goat -> Calico, Foo -> Zup, Frog -> Green)"

/* OUTPUT_SHOULD_BE
Map(Foo -> Bar)
Map(Foo -> Zup)
Map(Goat -> Calico, Foo -> Zup)
Map(Goat -> Calico, Foo -> Zup, Frog -> Green, Cow -> Brown)
Map(Goat -> Calico, Foo -> Zup, Frog -> Green)
Map(Goat -> Calico, Foo -> Zup, Frog -> Green)
*/
```

It works. It's clever and probably useful. But I worry about having to think this hard about something so apparently simple. It could be that I'm just not used to thinking "The Scala Way" yet. But it could also be that there are just a lot of special cases.

Once, I could run circles around C++ operator overloading, which is complicated because you have to worry about storage allocation and release (garbage collectors eliminate those problems). I don't remember that like I once did because C++ must be backwards compatible with C, and that introduced arbitrary complications which are essential to the language implementation rather than being essential to what you're trying to accomplish with the language. That's what makes the details hard to remember. And I find that if I can't hold important issues in my head, it slows me down. So that's what concerns me.
