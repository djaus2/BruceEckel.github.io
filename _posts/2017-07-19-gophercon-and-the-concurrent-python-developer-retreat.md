---
layout: post
published: false
title: Gophercon And The Concurrent Python Developer Retreat
---

Learn from Pycon

Luciano's spontaneous open space

the "community day" when everyone really started to connect

Nothing else to do during talks, unlike Pycon

A lot of people had either completely come over from Python or were
programming in both. A number of speakers told this story. My impression was
that the Python-Go crossover was the most common one, but that's probably
because I was particularly interested in it. I did find it a little
unfortunate that several of the speakers said mildly deprecating things about
Python, especially since I'd like to explore using Python everywhere possible,
for the power and development speed, and to see if Go can be used to solve
many of Python's concurrency issues.

Indeed, I went to Gophercon not just because Luciano asked me to, but  because
I hoped to understand more about Go's concurrency model. I came away with a much
better but far-from-perfect understanding of Go concurrency. Everything I've learned
so far continues to support the idea that Go can be used this way, at least for a
set of concurrency problems. So I want to continue that experiment.

I had a very interesting discussion with one person who is a big fan of both
Python and Go, and had a strong understanding of concurrency. He made a
fascinating observation, which is that there are areas where Go is "more
Pythonic" than Python, as per Tim Peters' [The Zen of
Python](https://www.python.org/dev/peps/pep-0020/). In particular, "There
should be one--and preferably only one--obvious way to do it." When it comes
to concurrency, there are many competing ways to solve that problem, and
the main fork happens between asynch (when you're waiting around for something
external to happen) and parallelism (when your problem takes lots of processing
power). The basic solutions in Python are `async/await` and `multiprocessing`.
But in Go, you don't have to think about the type of concurrency problem
you're solving; you just use goroutines for everything. Thus, more Pythonic.

I was especially interested in the [grpc](https://grpc.io/) cross-language
bridge. There was a presentation that used this, and they have working
examples, one of which is Python to Go, which I tested on my Windows 10
machine. The `grpc` unboxing experience was seamless and exceptionally good,
which means I'll probably explore it further when I need high-speed
foreign-function calls. There's a certain attraction to using something
supported by Google.

However, during the developer retreat, Jim Fulton told us about
[MessagePack](http://msgpack.org/) which has a [cross-language RPC
implementation](https://github.com/msgpack-rpc/msgpack-rpc) which also seems
worthy of exploration.

The conference made Go a particularly interesting way to offload concurrency
problems from Python. Using Go is the one solution we didn't get to during the
developer retreat, but I see a lot of possibility here for [Concurrent
Python](http://www.concurrentpython.com) and I intend to explore this avenue
further. I'm currently working my way through what I've been told is the
canonical Go book, [The Go Programming
Language](https://play.google.com/store/books/details?id=SJHvCgAAQBAJ&hl=en).

The Conconcurrent Python Developer Retreat
------------------------------------------

In this retreat, we were too ambitious. I've had plenty of experiences trying
to do too much, but the topic was interesting and we had some good minds
working on it so I got drawn into the enthusiasm.

We were too ambitious but we learned a great deal. We usually take more breaks
and do more outside activities, but our ambition drove us more this time so we
exhausted ourselves on a couple of occasions. I need to pay more attention to
this in the future and perhaps even add a little structure around breaks and
activities.

We did manage to get one walk in on the third day, after we had all gotten
mentally exhausted.

At Gophercon, Luciano and I talked to the folks at the **Twitch.tv** booth,
who convinced us that Twitch is about more than gaming, and that it would be a
good way to livestream programming events. This idea was interesting enough
that after Luciano told me Thoughtworks' choice for streaming camera and
microphone, I ordered them from Amazon so we could use them for part of the
conference. Alas, Amazon failed: the days kept passing and I kept hearing
about delays in delivery, so it never happened. Next time we'll give it a try.

As an experiment I bought a Google Chromecast perhaps a year ago. I've hardly
used it for anything, but during workshops it's priceless to be able to have
anyone in the room quickly and easily cast their desktop to the TV. We used
it almost constantly during this developer retreat.

Location of the repository. Remember we were in full exploration mode; pull
requests welcome.

One of the more illuminating days was the last one. We had been implementing
the photo-blurring problem using various techniques, and Jim Fulton kept
mentioning Rust. Jim had implemented a ZODB server in Rust a year before, so
it seemed like an ideal opportunity to learn more about this language. Lots of
people seem to use the refrain "I don't know much about Rust but it sounds
interesting and I'd like to explore it more." So I asked Jim if he'd be
willing to work through the photo-blurring problem in Rust and he agreed.

The first interesting thing was setup. Jim worked on this for awhile before
he just built the environment in a Docker container. This showed that Rust
is still in flux; there seemed to be language feature error messages that
popped up around libraries unless you had exactly the right combination
of compiler and tools; I think we ended up using the nightly build.

Jim hadn't done much with Rust in the past year, but before that he had built
a fairly complex piece of software. But in that year, many of the details of
Rust had slipped away from him and he had to recover them. I've had this same
experience with C++. When you have so many facets you need to keep in your
head, and when the features in question are not language-intuitive but rather
are low-level details necessary to satisfy some other need, then it's easy
to lose track of those details.

In the cast of C++, the extra mental baggage came from both the requirement of
backwards compatibility with C, and performance. This threw in lots of special
cases you had to remember. In the cast of Rust, there's no backwards-compatibility
issue, which was a relief, but that simplification was far more than overwhelmed
by all the performance issues.

From my limited exposure to the language, I feel safe in saying that the entire
*raison d'etre* of Rust is performance. You'd choose this language if you are
solving a problem fundamentally driven by performance. One oft-repeated use case
is rewriting [Firefox](https://mozilla.org/en-US/firefox/new) in Rust. Considering
how many people use web browsers, something like this could significantly reduce
power usage while at the same time increasing the responsiveness of the browser.
For this kind of problem it makes a lot of sense.

But the mental overhead and the amount of work necessary is enormous. In Rust you
must constantly pay attention to memory management. When you call a function, you
must also understand how your memory management is going to interact with
that function, and make decisions about it. This is on top of the complexity of
the language. My perception is that if you decide to create a project in Rust, you
must live and breathe that language and it will completely occupy your brain, with
no room for any other language.

Before committing to Rust for a project, you must be very clear that the costs
are worth the benefits. Rewriting FireFox, for sure. But for a problem like
ours it wasn't clear that the performance was faster than the other
approaches. This might well be due to a poor implementation of the Rust image
processing library we used, but after all the work it would be pretty
disappointing to discover that a solution in Go or even Python was around the
same speed or even faster.

Rust is not the language I'm seeking because it's not a rapid-development
solution, so I'm putting it on the back shelf for the time being. I can
definitely imagine projects where it could be a good solution, but I doubt I'd
want to work on those projects.

Once I get far enough through the Go book, I want to try implementing the
image-processing problem in Go and see what kind of performance comes from
that. In my mind, it's about achieving desired results while minimizing
development effort.
