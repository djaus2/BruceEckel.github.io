---
layout: post
published: false
title: A Heaping Helping Of Python Goodness
---
I really enjoy solving problems quickly and thoroughly. I especially enjoy solving annoying, repetitive problems that invite human error. The icing on the cake is when I learn some new tricks in the process. This last few days was a flurry of problem-solving and trick-learning.

My favorite tricks are small bits of learning that make code easier to write, read and use. A couple of these are Windows-specific but most are general.

## 1. Turn a Python Program into a Windows Batch File ##

I'm lazy and I don't like typing more than I have to. Even better is to just double-click on a thing from the Windows Explorer. I've tried doing this in the past but it was ugly and I always had to fiddle around with it, so when I found a universal solution on the Internet I was quite pleased. So far, putting the first line at the top of a batch file has worked everywhere I've tried it:

```python
@setlocal enabledelayedexpansion && python -x "%~f0" %* & exit /b !ERRORLEVEL!
#start python code here (tested on Python 2.7.4)
```
It has the additional benefit that generic scripts are easily adaptable for non-Windows machines --- just take out the first line.

## 2. "with" and the Context Manager ##

The **with** keyword has been in Python for awhile now; the simplest way of thinking about it is that it sets up a **try-finally** block for you. One of the things I love most about Python is that the language designers pay attention to the little things that people do over and over and think "hey, maybe we can make this better!" So sure, you can write your own **try-finally** blocks to do this, but if it gets too messy you won't.

Here, I just wanted to visit a directory, do something, and come back. I found myself doing this in numerous places in the program, so to prevent errors and make the code clearer, I decided to try to do the repetitive activity in one place.

You can write your own context manager class, but in many cases you can do it much more simply using the **contextmanager** decorator on a function. The **yield** in the middle of the function is where you'd normally have all your actions in the **try** block, and the code after the **yield** is what would happen in the **finally** block:

```python
import os
from glob import glob
from contextlib import contextmanager

@contextmanager
def visitDir(d):
    old = os.getcwd()
    os.chdir(d)
    yield d
    os.chdir(old)

paths = [os.path.join('.', p[0:-1]) for p in glob('*/')]

for p in paths:
    with visitDir(p):
        print p + ": "
        for f in glob('*'):
            print "   ", f
```
The program just visits each directory one level down from the current one and prints the contents.

Because of the simplicity of the **contextmanager** decorator, I'm going to be using **with** statements a lot more now.

## 3. Command-line Arguments with argparse ##

In the past, I've tried to use **optparse** but it always ended up feeling too messy and complicated, so I'd just punt and pick the arguments off the command-line myself. Apparently powers that be observed this happening enough that someone decided to create a simpler, better command-line parsing module. I finally reached for [argparse](http://pymotw.com/2/argparse/) this week, and I'm now a convert --- argument parsing has become easy, and I won't hesitate to put it into future programs.

Here's a simple example that only uses optional flags, which can come in a single-hyphen short form or a double-hyphen long form:

```python
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-r", "--run", action='store_true',
    help="Run all the scala scripts and capture any errors")
parser.add_argument("-s", "--simplify", action='store_true',
    help="Remove unimportant trace files & show non-empty error files")
parser.add_argument("-c", "--clean", action='store_true',
    help="Remove all 'run' artifacts")
parser.add_argument("-p", "--prerequisites", action='store_true',
    help="Compile prerequisites")
parser.add_argument("-u", "--unusedfiles", action='store_true',
    help="Display non 'Solution-' and non 'Starter-' scala files")
parser.add_argument("-t", "--test", action='store_true',
    help="Test")
args = parser.parse_args()

if not any(vars(args).values()): parser.print_help()
if args.test:
    print "test"
if args.clean:
    print "clean"
if args.prerequisites:
    print "prerequisites"
if args.run:
    print "run"
if args.simplify:
    print "simplify"
if args.unusedfiles:
    print "unusedfiles"
```

If you have a dash or double-dash in front of an argument, that argument is automatically optional. The default is that arguments can be in any order. It's also possible to have argument parameters and pretty much any other configuration you need; see the above link for details.

You create an **ArgumentParser**, then add arguments. Note that I use both the short and long form of arguments, followed by **action='store_true'** which puts a Boolean in that argument's location when it finds the flag. Then you can just perform tests such as **if args.clean** in your code. 

The **help** text is displayed when you ask for help with the flag **-h** or **--help**, and I've also explicitly called **parser.print_help()** if no flags at all are present; that way if you just run the command you get the help text:

```
c:\tmp>python argparse-example.py -t -u -r
test
run
unusedfiles

c:\tmp>python argparse-example.py
usage: argparse-example.py [-h] [-r] [-s] [-c] [-p] [-u] [-t]

optional arguments:
  -h, --help           show this help message and exit
  -r, --run            Run all the scala scripts and capture any errors
  -s, --simplify       Remove unimportant trace files & show non-empty error
                       files
  -c, --clean          Remove all 'run' artifacts
  -p, --prerequisites  Compile prerequisites
  -u, --unusedfiles    Display non 'Solution-' and non 'Starter-' scala files
  -t, --test           Test
```

You'll notice that the arguments make this look like a kind of build program, which it is. I seem to reinvent **make**-like build tools on a regular basis, but **argparse** has me thinking that, with enough built-in tools like Python provides, I might not need a build framework --- perhaps all I need to do is use the tools to create a custom builder for each need.

## Creating Standalone Executables with PyInstaller ##

Here's another problem that I've poked at for years --- well, looked at and decided it was too much trouble. And this week, discovered that someone has made it easy with [PyInstaller](https://github.com/pyinstaller/pyinstaller/wiki).

James needed the Windows installer to be dead simple

## Simplifying Configuration ##


