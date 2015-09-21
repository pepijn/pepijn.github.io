---
layout:     post
title:      A geoJSON travel log using Emacs Org mode and Babel
summary:    
categories: emacs org-mode git geojson
---

tl;dr: I played around with Emacs Org mode and Babel and mapped my summer holiday to the
geoJSON format. [This](https://github.com/pepijn/travel_log/blob/master/my_summer_2015.geojson) is the result, [rendered](https://help.github.com/articles/mapping-geojson-files-on-github/) by GitHub:
[![](https://raw.githubusercontent.com/pepijn/travel_log/03c34c500a0251dbbaa2430eb7a643de2b4ab6f0/media/geojson_github_2.png)](https://github.com/pepijn/travel_log/blob/master/my_summer_2015.geojson)

## Why

A couple of months ago, I came across [this post on the GitHub blog](
https://github.com/blog/1541-geojson-rendering-improvements) about geoJSON
rendering improvements. The rendering of this format was great and so was my
desire to built something with it. As these things go, it did not materialize
because of priorities. Nevertheless, the idea rested somewhere in the back of my
head, until me and my friends came back from a road trip through South-Eastern
Europe. Finally, I had an excuse to build something related to geoJSON: a travel
map depicting our route. Furthermore, keeping better track of my trips has been
my wish for a longer time, so why not take this opportunity to kill two birds
with one stone.

Why would anyone build *yet another* travel log appliance though? The existing
solutions, such as the (in)famous Dutch [WaarBenJij.nu](http://waarbenjij.nu)
(translation: WhereAreYou.now), work fine. Besides having fingerlicking visual
appeal, WaarBenJij.nu must have a great user interface–judging by the amount of
users they have... Anyhow, disregarding user experience and whatnot, the matter
that interests me the most is where and how your data are stored. If I take the
hard effort to type out my journeys, I want to make sure that the data are
accessible and transparent in case the travel log internet company buys a
metaphorical one-way ticket to a remote tropical island and never returns (with
my data).

## What

In other words, my plan was worth implementing if it adhered to the following
specifications:


1. ✔ Effortless visualization: [GitHub geoJSON rendering](https://help.github.com/articles/mapping-geojson-files-on-github/)
2. ✔ (hopefully) Future-proof standards-compliant data format: [geoJSON](http://geojson.org/)
3. ✔ Transparent and reliable data storage: [Git](https://git-scm.com/)
4. Human-friendly interface

## How

Unfortunately, the fact that three quarters of the specifications had been
fulfilled before beginning any work turned out to be deceiving. My first attempt
was a one-off command-line app. I found out that one-off command-line apps are
not the best user experience for repetitive data entry. The insertion of dates
and geolocations should probably be much easier when executed in a web
browser. What followed was an impatient and pathetic attempt of building a
Sinatra app that was halted almost as soon as it was started. I lost interest.

A few weeks later, while browsing
[the excellent Emacs Reddit top list](https://www.reddit.com/r/emacs/top/), a
post called
'[Literate Devops](https://www.reddit.com/r/emacs/comments/3jx6bx/literate_devops_with_emacs/)'
caught my attention. The link was clicked,
[the video](https://www.youtube.com/watch?v=dljNabciEGg) seen, and my
[mind blown](http://giphy.com/gifs/reaction-adult-swim-mind-blown-jCMq0p94fgBIk). Howard
Abrams is executing code in various languages (in his example Shell and Python)
in one `org-mode` file, using
[Babel](http://orgmode.org/worg/org-contrib/babel/). Moreover, the results of
the code blocks are outputted as `org-mode` tables, that consequentely get
passed as input to other code blocks. Together with the 'comments as first-class
citizen',
[literate programming](https://en.wikipedia.org/wiki/Literate_programming)
seemed like an intriguing way to build software.

[![](/images/howard_abrams.png)](https://www.youtube.com/watch?v=dljNabciEGg)
Howard Abram's Literate Devops video

Was Emacs with org-mode and Babel the way to go, with respect to the
human-friendly interface for my travel log project? The org-mode tables were not
unfamiliar to me. I have used them to do Spreadsheet-like calculations before,
which worked really well. In the same way, they turned out to be excellent for
repetitive data entry. Especially when using `C-c .` (`org-time-stamp`) to
insert dates. All specifications were finally fulfilled and the project
implemented.

The gif below is me doing the following things:

1. Cloning [my personal `travel_log` example repository](https://github.com/pepijn/travel_log) and opening it
2. Loading the state from the `geojson` file into the `org-mode` table
3. Insert a row into the travel log so it includes a short trip to the [Easter Island](https://en.wikipedia.org/wiki/Easter_Island)
4. `C-c C-v C-b` (`org-babel-execute-buffer`) it (among other things, also pushes to GitHub)
5. Refreshing the GitHub geoJSON rendering and observing the newly added trip across the world!

![](https://raw.githubusercontent.com/pepijn/travel_log/master/media/demo.gif)

## Conclusion

Org mode and Babel are great for everything etc etc
