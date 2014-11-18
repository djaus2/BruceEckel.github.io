---
layout: post
title: Using Github Pages for Blogging
---

I've wanted to move my programming blog away from [Artima](http://www.artima.com/weblogs/index.jsp?blogger=beckel) for what seems like several years now.My buddy Bill hasn't found the blogging platform to be of much interest anymore, and in particular he realizes there are many better alternatives at this point.

The conversion took a surprising amount of research, partly because I've been away from the idea of blogging technology for quite awhile. Initially I hosted my own blogs on my own site, writing the necessary code by hand. Eventually I moved to Artima and relied on that site to provide the blogging framework. I've mostly skipped the need for Wordpress, although [www.AtomicScala.com](http://www.atomicscala.com/) is a Wordpress site. Wordpress and PHP have moved the web forward so they deserve credit for that, but for me Wordpress requires too much fiddling --- and that requires a mental shift away from what you want to do that I find too disruptive when what I'm trying to do is write a post.

Then there's the issue of the "programming blog." We especially need to be able to show code listing easily. So, although I've been satisfied with Blogger for the Reinventing Business blog, the fact that Blogger doesn't natively support code listings is a deal-breaker (yes, I know there are tools to format your listings, but that's too much overhead, and fiddly).

When you start researching, you discover that there's been a big movement in recent years to static site generators. These have 

[Here's an extremely thorough article](http://www.smashingmagazine.com/2014/08/01/build-blog-jekyll-github-pages/) on Jekyll and Github pages.

No search function comes with Jekyll, so I added [Simple Jekyll Search](https://github.com/christian-fei/Simple-Jekyll-Search) to my popup sidebar.

One more simplification step remained. Jekyll requires you to name your posts in a particular way, and provide header information at the top of the source file for each post. To avoid duplication of effort, I decided to automate this, and naturally I reached for Python to achieve the automation.
