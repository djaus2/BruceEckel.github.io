---
layout: post
published: true
title: A Canonical equals() For Java
---

> Even with the help of Java 7's `Objects.equals()`, the `equals()` method often
> being verbose and messy. This article shows how you can write a succinct `equals()`
> in a format that allows easy checking with visual inspection.

There are a number of checks you must ensure to properly determing whether the
object you're comparing yourself to (which we'll call here the **rval**) is
equal to this object:

1.  If the **rval** is `null`, it's not equal.

2.  If the **rval** is `this` (you're comparing yourself to yourself),
    the two objects are equl.

3.  If the **rval** is not the same class or subclass, the two objects are not
    equal.

4.  If all the above checks pass, then you must decide which fields in the
    **rval** are important, and compare those.

Java 7 introduced the `Objects` class to help with this process, which we use
to write a better `equals()`.

The following examples compare different versions of the `Equality` class. To
prevent duplicate code we'll build the examples using the *Factory* method
design pattern. The `EqualityFactory` interface simply provides a `make()`
method to produce an `Equality` object, so a different `EqualityFactory` can
produce a different subtype of `Equality`:

```java
// EqualityFactory.java
import java.util.*;

interface EqualityFactory {
  Equality make(int i, String s, double d);
}
```

Now we'll define `Equality` containing three fields (all of which we consider
important during comparison) and an `equals()` method that fulfills the four
checks described above. The constructor displays its type name to ensure we are
performing the tests we think we are:

```java
// Equality.java
import java.util.*;

public class Equality {
  protected int i;
  protected String s;
  protected double d;
  public Equality(int i, String s, double d) {
    this.i = i;
    this.s = s;
    this.d = d;
    System.out.println("made 'Equality'");
  }
  @Override
  public boolean equals(Object rval) {
    if(rval == null)
      return false;
    if(rval == this)
      return true;
    if(!(rval instanceof Equality))
      return false;
    Equality other = (Equality)rval;
    if(!Objects.equals(i, other.i))
      return false;
    if(!Objects.equals(s, other.s))
      return false;
    if(!Objects.equals(d, other.d))
      return false;
    return true;
  }
  public void
  test(String descr, String expected, Object rval) {
    System.out.format("-- Testing %s --%n" +
      "%s instanceof Equality: %s%n" +
      "Expected %s, got %s%n",
      descr, descr, rval instanceof Equality,
      expected, equals(rval));
  }
  public static void testAll(EqualityFactory eqf) {
    Equality
      e = eqf.make(1, "Monty", 3.14),
      eq = eqf.make(1, "Monty", 3.14),
      neq = eqf.make(99, "Bob", 1.618);
    e.test("null", "false", null);
    e.test("same object", "true", e);
    e.test("different type", "false", new Integer(99));
    e.test("same values", "true", eq);
    e.test("different values", "false", neq);
  }
  public static void main(String[] args) {
    testAll( (i, s, d) -> new Equality(i, s, d));
  }
}
/* Output:
made 'Equality'
made 'Equality'
made 'Equality'
-- Testing null --
null instanceof Equality: false
Expected false, got false
-- Testing same object --
same object instanceof Equality: true
Expected true, got true
-- Testing different type --
different type instanceof Equality: false
Expected false, got false
-- Testing same values --
same values instanceof Equality: true
Expected true, got true
-- Testing different values --
different values instanceof Equality: true
Expected false, got false
*/
```

`testAll()` performs comparisons with all different types of objects we ever
expect to encounter.

In `main()`, notice the simplicity of the call to `testAll()`. Because
`EqualityFactory` has a single method, it can be used with a lambda expression
as the `make()` method.

The above `equals()` method is annoyingly verbose, and it turns out we can
simplify it into a canonical form. Observe:

1.  The `instanceof` check eliminates the need to test for `null`

2.  The comparison to `this` is unneccessary.

Because `&&` is a short-circuiting comparison, it quits and produces `false`
the first time it encounters a failure. So, by chaining the checks together
with `&&`, we can write `equals()` much more succinctly:

```java
// SuccinctEquality.java
import java.util.*;

public class SuccinctEquality extends Equality {
  public SuccinctEquality(int i, String s, double d) {
    super(i, s, d);
    System.out.println("made 'SuccinctEquality'");
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof SuccinctEquality &&
      Objects.equals(i, ((SuccinctEquality)rval).i) &&
      Objects.equals(s, ((SuccinctEquality)rval).s) &&
      Objects.equals(d, ((SuccinctEquality)rval).d);
  }
  public static void main(String[] args) {
    Equality.testAll( (i, s, d) ->
      new SuccinctEquality(i, s, d));
  }
}
/* Output:
made 'Equality'
made 'SuccinctEquality'
made 'Equality'
made 'SuccinctEquality'
made 'Equality'
made 'SuccinctEquality'
-- Testing null --
null instanceof Equality: false
Expected false, got false
-- Testing same object --
same object instanceof Equality: true
Expected true, got true
-- Testing different type --
different type instanceof Equality: false
Expected false, got false
-- Testing same values --
same values instanceof Equality: true
Expected true, got true
-- Testing different values --
different values instanceof Equality: true
Expected false, got false
*/
```

For each `SuccinctEquality`, the base-class constructor is called before the
derived-class constructor. The output shows that we still get the correct
result. You can tell that short-circuiting happens because both the `null`
test and the "different type" test would otherwise throw exceptions during
the casts that occur further down the list of comparisons in `equals()`.

`Objects.equals()` shines when you compose your new class using another class:

```java
// ComposedEquality.java
import java.util.*;

class Part {
  String ss;
  double dd;
  public Part(String ss, double dd) {
    this.ss = ss;
    this.dd = dd;
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof Part &&
      Objects.equals(ss, ((Part)rval).ss) &&
      Objects.equals(dd, ((Part)rval).dd);
  }
}

public class ComposedEquality extends SuccinctEquality {
  Part part;
  public ComposedEquality(int i, String s, double d) {
    super(i, s, d);
    part = new Part(s, d);
    System.out.println("made 'ComposedEquality'");
  }
  @Override
  public boolean equals(Object rval) {
    return rval instanceof ComposedEquality &&
      super.equals(rval) &&
      Objects.equals(part, ((ComposedEquality)rval).part);
  }
  public static void main(String[] args) {
    Equality.testAll( (i, s, d) ->
      new ComposedEquality(i, s, d));
  }
}
/* Output:
made 'Equality'
made 'SuccinctEquality'
made 'ComposedEquality'
made 'Equality'
made 'SuccinctEquality'
made 'ComposedEquality'
made 'Equality'
made 'SuccinctEquality'
made 'ComposedEquality'
-- Testing null --
null instanceof Equality: false
Expected false, got false
-- Testing same object --
same object instanceof Equality: true
Expected true, got true
-- Testing different type --
different type instanceof Equality: false
Expected false, got false
-- Testing same values --
same values instanceof Equality: true
Expected true, got true
-- Testing different values --
different values instanceof Equality: true
Expected false, got false
*/
```

Notice the call to `super.equals()`---no need to reinvent it (plus you don't
always have access to all necessary parts of a base class).
