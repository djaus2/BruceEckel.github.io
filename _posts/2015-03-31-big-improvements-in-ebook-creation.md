---
layout: post
published: false
title: Big Improvements In Ebook Creation
---

I just finished the eBook of the [2nd edition of Atomic Scala](http://www.AtomicScala.com). The PDF is, of course, the easiest since it gets created directly from Word (before you tell me I should use something other than Word --- I have done numerous experiments, and Word still provides the most power of anything I've found that allows a single document to produce camera-ready publishable pages, and at the same time generates and maintains a table of contents and index).

Two years ago, for the first edition of the book, the drudgery of figuring out the right way to generate the other eBook formats (mobi for the Kindle and epub for everything else) stretched out for months. It was ultimately interesting and the Python programming was kind of satisfying and fun, but the fiddly-ness of the formats was often maddening.

So even though I had a big Python build script to make everything as automatic as possible, I was gritting my teeth expecting to have to wade into the morass once again.

To convert a book to mobi and epub, you first need very clean HTML as a starting point. More recent versions of Word have included "save as Web Page - filtered" which produces much cleaner HTML than before that option existed. Much of my build script is focused on that cleaning, using [Leonard Richardson's wonderful BeautifulSoup4](http://www.crummy.com/software/BeautifulSoup/bs4/doc/) Python library (I know of nothing that comes even close for any other language), and when I couldn't figure out the right Beautiful Soup incantation, a few regular expressions.

Some things had changed, so I had to go through and fix up issues in the Python build script (which uses [Paver](http://paver.github.io/paver/)), but eventually got to the point where I had super-clean HTML and an associated CSS script.

I used [Calibre](http://calibre-ebook.com/) the last time around, and it did a very good job but still required a fair amount of fiddling. The Caliber creator, Kovid Goyal, has been upgrading it a lot over the last couple of years, so I started by throwing in my cleaned HTML, adding a cover and generating an epub just to see what kinds of problems I would have to struggle with.

To my surprise, the result was ... perfect, as far as I could tell. With no adjustments at all the output was flawless on the iPad. Calibre has really upped its quality (it was great before, but this!). I was also a bit spoiled, now, after having imagined days or weeks of effort in my future.

Alas, Calibre's mobi output was no where near good enough. And whatever steps I had taken in the past didn't look like they were going to work, so I was getting emotionally ready to roll up my sleeves and submerge myself in the sewage that is the mobi spec and tools.

As a last ditch, I thought I'd Google for something that might convert epub to mobi, and lo and behold discovered [epub2mobi.com](http://www.epub2mobi.com/). To give perspective, at one point two years ago I had even tried hiring a service to do the conversion, but they couldn't handle things like special formatting and embedded fonts. So I was pretty skeptical, and then surprised and amazed when the epub2mobi conversion worked flawlessly! Suddenly, many days of slogging through specs and writing experiments vanished. What a delight! I sent them a thank-you note and some money.

I thought I had a lot more work to do to get the epub and mobi versions for Atomic Scala 2nd edition, but these two programs just made it work like magic.

**Note:** If you start with a Word document and save it as "filtered HTML" Calibre will do quite a good job on it. For a book with just text or relatively simple formatting, it should work fine (I had to process my HTML to get it just right, but most books don't have the formatting etc. requirements I do, and Calibre still did a remarkably good job with the raw HTML despite my issues). If you work with a word processor or other tool that produces really clean HTML directly then you're in even better shape.