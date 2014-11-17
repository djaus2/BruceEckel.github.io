@setlocal enabledelayedexpansion && python -x "%~f0" %* & exit /b !ERRORLEVEL!
#start python code here
import os
import easygui # to install: pip install EasyGUI
result = easygui.enterbox(msg="Blog Post Title", title="Name query")
print result

slugline = """
---
layout: post
title: What's Jekyll?
---
"""

os.startfile("2013-12-31-whats-jekyll.md")