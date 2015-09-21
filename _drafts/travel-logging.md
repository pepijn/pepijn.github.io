---
layout:     post
title:      geoJSON travel log using Emacs org-mode
summary:    
categories: emacs org-mode git geojson
---

tl;dr: I played around with Emacs' org-mode and mapped my road trip from this
summer to the geoJSON format and this is the result:

<script
src="https://embed.github.com/view/geojson/pepijn/travel_log/master/my_summer_2015.geojson?width=719"></script>

## Why

A variety of stuff intersected last summer that led me to building this
thing. That was:

1. Reading the GitHub blog post
2. Wanting to make a travel log that saves all my travels
3. Coming back from this road trip and showing people where we went

## What

After I came back from the road trip I wanted to map the it and also for other
trips I have done and will do in the future. Or just because I like maps and I
wanted to play with the geoJSON format (insert GH blog link). There are various
websites that let you do this, but they all have a pretty bad interface and are
online services. When they stop you lose your data. Just like everyone carefully
keeps their own backups of all the photos they have and it wouldn't cross their
mind just storing it on Facebook to keep it eternally, I wanted to do
thi son my own. So I set out to built it my own and created a list of
specifications:


1. Always look back at the places I have been This log will persist, unlike an
2. online cloud based log that shuts down when the company goes bankrupt It is. A Google search for 'online travel log' yields about 500 million results. I'm gonna add one to it
3. easy to generate a nice map. Piggybacking on GitHub for this.  Easy adding of
4. destinations by command line or other interface

## How

Somewhere in the back of my head I had this [blog post on the GitHub blog](
https://github.com/blog/1541-geojson-rendering-improvements) I knew that if i
wanted to built this I wanted to do it in geoJSON. If GitHub supports the format
it must means it's good right?

I played around with a CLI app, tried it in Sinatra but it all quite sucked and
I lost interest. And I did not want to spend any time on it because I had more
important work to do. Through
[the excellent resource top list of Reddit Emacs](https://www.reddit.com/r/emacs/top/)
I stumbled upon this video. mind= blown

<iframe width="560" height="315" src="https://www.youtube.com/embed/dljNabciEGg" frameborder="0" allowfullscreen></iframe>

After watching this video https://www.youtube.com/watch?v=dljNabciEGg I was
inspired to use org-mode for this purpose. I read the [Babel docs](http://orgmode.org/worg/org-contrib/babel/) and started
playing with it. The pace of development is crazy high. And using the org-tables
as a way of communication between various src blocks is a really nice way of
adhering to the Unix philosophy. I have been playing with IPython for some
statistics stuff but this is definitely better. It is the smoothest
implementation of the Unix rules I have seen yet.

- Rule of Modularity
- Rule of Clarity
- Rule of Composition
- Rule of Separation
etc.

![](https://raw.githubusercontent.com/pepijn/travel_log/master/media/demo.gif)
