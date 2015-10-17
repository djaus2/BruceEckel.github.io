---
layout: post
published: false
title: Are Java 8 Lambdas Closures?
---

Based on what I've heard, I was surprised to discover that the short answer
is "yes, with a caveat that, after explanation, isn't really a caveat." So,
yes.

For the longer answer, we must first explore the question of "why, again,
are we doing all this?"

## Functional Programming

Lambdas/Closures are there to aid functional programming. Java 8 is not
suddenly a functional programming language, but (like Python) now has some
support for functional programming.

The core idea of functional programming is that you can create and
manipulate functions, including creating functions at runtime. Thus,
functions become another thing that your programs can manipulate (instead
of just data). This adds a lot of power to programming.

A *pure* functional programming language includes other restrictions,
notably data invariance. That is, you don't have variables, only
unchangeable values. This sounds overly constraining at first (how can you
get anything done without variables?) but it turns out that you can
actually accomplish everything with values that you can with variables (you
can prove this to yourself using Scala, which is itself *not* a pure
functional language but has the option to use values everywhere). Invariant
functions take arguments and produce results without modifying their
environment, and thus are much easier to use for parallel programming.

Before Java 8, the only way to create functions at runtime in Java was
through bytecode generation and loading (which quite messy and complex).

Lambdas provide two basic features:

1. More succinct function-creation syntax.

2. The ability to create functions at runtime, which can then be
passed/manipulated by other code.

Closures concern this second issue.

## What is a Closure?

A closure solves the problem of a function using variables that are outside
of the function scope. This is not a problem in traditional procedural
programming -- you just use the variable -- but when you start producing
functions at runtime it becomes a problem. To see the issue, I'll start
with a Python example. Here, `make_fun()` is creating and returning a
function called `func_to_return`, which is then used by the rest of the
program:

```python
# Closures.py

def make_fun():
    # These are outside the scope of the returned function:
    alist = []
    n = 0

    def func_to_return(arg):
        nonlocal n
        # Without 'nonlocal' n += arg produces:
        # local variable 'n' referenced before assignment
        n += arg
        alist.append(arg)
        return (alist, n)

    return func_to_return

x = make_fun()
y = make_fun()

for i in range(10):
    list_x, xn = x(i)
print(list_x, xn)

for i in range(10, 20):
    list_y, yn = y(i)
print(list_y, yn)

""" Output:
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9] 45
[10, 11, 12, 13, 14, 15, 16, 17, 18, 19] 145
"""
```

Notice that `func_to_return` manipulates two fields that are outside its
scope: `x` and `alist`. The `nonlocal` declaration is required because of
the way Python works: if you just start using a variable, it assumes that
variable is local. Here, the compiler (yes, Python has a compiler and yes,
it actually does some -- admittedly quite limited -- static type checking)
sees that `x += arg` uses `x` which, within the scope of `func_to_return`,
hasn't been initialized, and generates an error message. But if we say that
`x` is `nonlocal`, Python realizes that we're using the `x` outside the
function scope, and that `x` *has* been initialized, so it's OK. And even
without the `nonlocal` declaration, it also recognizes that `alist` is a
reference to a `list` and allows it (built-in collections get special
treatment).

Now we encounter the problem: if we simply return `func_to_return`, what
happens to `x` and `alist` which are outside the scope of `func_to_return`?
Ordinarily we'd expect those elements to go out of scope and become
unavailable, but if that happens then `func_to_return` won't work. In order
to support dynamic creation of functions, `func_to_return` must "close
over" both `x` and `alist` when it's returned, and that's what happens --
thus the term *closure*.

To test `make_fun()`, we call it twice and capture the resulting function in `x` and `y`.
