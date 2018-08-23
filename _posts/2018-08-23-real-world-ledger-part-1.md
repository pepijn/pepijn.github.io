---
layout:     post
title:      "Real World Ledger part 1: Weighing Eggs in Baskets"
categories: ledger-cli accounting
published:  true
---

Do you ever feel like you're losing grip of your personal finances? You deposit
into your savings account in one currency, buy stocks and bonds in another, and
maybe even hodl on to some cryptocurrency. You keep a finger on the pulse and
ocassionally check your assets' value, but volatile prices and exchange rates
make it challenging. Ledger is a command line accounting tool that addresses
these issues. In this post I'll introduce you to it.

## Introduction

The world around you is changing: interest rates on savings accounts slide to
0%, stock markets bubble and crash, and global political debate
intensifies. Above all, your bank or government expects you to pay back that
student loan sometime in the future. It is safe to say that our economy is a
rough sea.

This post is part one in a series where I show how to map and plan your
financial positions in Ledger so you're able to navigate those real world issues
with confidence. How to do that exactly isn't trivial, though. With this blog
series I hope to fill that skills gap&#x2014;the same that I encountered when
starting with Ledger. I found many online examples too abstract and missing
human/societal context for someone unfamiliar with accounting.

That said, I won't be explaining you the theory behind techniques like
double-entry accounting and investment portfolios in this post because I am
neither an accountant nor am I an investment advisor. The Ledger documentation
does a good job at explaining double-entry<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup> and Investopedia
explains portfolios well<sup><a id="fnr.2" class="footref" href="#fn.2">2</a></sup>. I will limit myself to the
narrative and practical examples&#x2014;those are the things I've personally
experienced.

## Part 1: Weighing Eggs in Baskets

The example story through this blog series features the development of a basic
financial situation into an investment portfolio with carefully weighted stocks,
government bonds, cryptocurrency, and of course cash. All is fine and balanced
until a cryptocurrency hype comes knocking at the door and exposes the portfolio
manager, you, to a novel risk.

We get started in this post by diversifying our savings into stocks, bonds, and
cryptocurrency. This way, we won't have all our eggs in one basket. We also
discuss how you convert different assets to one currency so we can realiably
weigh them: apples to apples. The weighing is essential when creating your
investment portfolio **allocation**&#x2014;which we'll discuss in the next post.

> "Ledger is a powerful, double-entry accounting system that is accessed from the
> UNIX command-line." &#x2014; <https://www.ledger-cli.org>

To follow along with the story below, you will need a terminal with Ledger
installed and a plain text file editor, such as Sublime Text. If you use macOS,
installing Ledger is easy using [Homebrew](https://brew.sh/): `brew install ledger`. Feel free to
make your workflow more pleasant by installing a Ledger mode in your text
editor&#x2014;this gives you syntax highlighting. Sublime and other well-known
editors (like Emacs and vim) have Ledger modes readily available online.

### The basics: single currency and single asset class

#### Our first posting: adding our savings account

Let's start simple: we have a savings account at a bank called ASN
bank<sup><a id="fnr.3" class="footref" href="#fn.3">3</a></sup> in our home country where most of our money resides. This
account already has money in it&#x2014;obviously we don't start owning assets the
moment we begin using Ledger&#x2014;so we have to initialize our balance by moving
money from *somewhere*. Idiomatically that *somewhere* is an account called
'opening balances'. When we express this in Ledger, this is what the file
`postings1.dat` (`.dat` is commonly used with Ledger, but feel free to use
something else like `.txt`) looks like:

{% highlight ledger %}
2018-01-01 Opening Balances
    Assets:NL:ASN:Savings                 € 1,337.00
    Equity:Opening Balances              € -1,337.00
{% endhighlight %}

How do we interpret these three lines? Every posting has a date (`2018-07-01`)
and a payee (`Opening Balances`). Then, what follows directly beneath it are the
entries belonging to that posting. In this case we move the `€ 1337` from
'opening balances' to the savings account. Most of the labels here are arbitrary
and depend on your preference and taste. I like to structure actual bank
accounts as follows: country, name of bank, type of account. That results in
`Assets:NL:ASN:Savings`.

Now we run our first query using the Ledger command line tool. We ask for the
`balance` of accounts that match `assets` in the file `postings.dat`.

{% highlight bash %}
ledger --file postings1.dat balance assets
{% endhighlight %}

The result, as expected, the balance of one asset account:

{% highlight plaintext %}
          € 1,337.00  Assets:NL:ASN:Savings
{% endhighlight %}

#### Our first mutation: interest from savings, and deposits and withdrawals

Fast forward 6 months. We have received some interest from the bank and did a
couple of deposits and withdrawals. We could add postings for all the deposits
and withdrawals, but that's a lot of premature work and definitely not the
required to benefit from Ledger. That's why we're using an 'adjustment' account
in the following **addition** to our `postings1.dat` file, calling it
`postings2.dat`.

{% highlight ledger %}
2018-06-01 ASN
    Assets:NL:ASN:Savings                 € 3,787.50 = € 1,337
    Income:Interest                         € -42
    Equity:Adjustment
{% endhighlight %}

A net amount of € 3,787.50 was added to the savings account (the equals sign (=)
adds a check that the balance of the account after the mutation is exactly €
1,337), of which € 42 was interest received on the principal. The rest was
the result of deposits and withdrawals. We don't really care about tracking all
those transactions in detail right now, so we lazily use an adjustment
account. Lastly, we're able to omit the amount for `Equity:Adjustment` because
there's only one possibility: `€ -3,787.50 - € 42 = € -3,745.5`.

The adjustment account resolves a common discouragement of adopting Ledger that
I keep hearing&#x2014;people think that Ledger requires them to arduously type in all
transactions like a monkey. You don't, and above all you can always do that
later or build scripts to do it for you should you so desire.

We now rerun the Ledger command line tool. This time, we ask for the `balance`
of all accounts, not just assets:

{% highlight bash %}
ledger --file postings2.dat balance
{% endhighlight %}

Please note that the total of all accounts always sums to zero&#x2014;that condition
is the main property of double-entry accounting:

### Going deeper: multiple currencies and asset classes

#### Diversifying into multiple assets

We decided to diversify, hoping to get a better return than the ~0% interest
rate on your savings account<sup><a id="fnr.4" class="footref" href="#fn.4">4</a></sup> in our ~2% inflation
habitat<sup><a id="fnr.5" class="footref" href="#fn.5">5</a></sup>. But, at the same time, you don't want to go all-in on
stocks because it's generally considered a bad idea to put all your eggs in one
basket. That's why we diversify and buy some government bonds and cryptocurrency
too. 'Interactive Brokers' and 'Binck Bank' in the file below are examples of
stock/bonds brokers. `postings3.dat`:

{% highlight ledger %}
2018-07-01 Interactive Brokers
    Assets:NL:ASN:Savings                   € -1,285
    Assets:US:Interactive Brokers:Cash       $ 1,500

2018-07-02 Binck Bank
    Assets:NL:ASN:Savings                   € -2,000
    Assets:NL:BinckBank:Cash

2018-07-03 Interactive Brokers
    Assets:US:Interactive Brokers:Stocks      6 AAPL @ $ 183.92
    Assets:US:Interactive Brokers:Cash

2018-07-04 Binck Bank
    Assets:NL:BinckBank:Bonds      1,100 "NL2014-47" @ € 1.39
    Assets:NL:BinckBank:Stocks                5 HEIA @ € 86.08
    Assets:NL:BinckBank:Cash

2018-07-05 Coinbase
    Assets:Cryptocurrency:BTC wallet         BTC 0.1
    Assets:NL:ASN:Savings                     € -561
{% endhighlight %}

In the example above we use different syntax to reach the same goal: buying one
commodity by selling another commodity (such as stocks from US dollars and
Bitcoin from euros). The Ledger docs explain the differences
clearly<sup><a id="fnr.6" class="footref" href="#fn.6">6</a></sup>.

Let's check the impact of our asset diversification buying spree on our balance:

{% highlight bash %}
ledger --file postings3.dat balance assets --no-total --flat
{% endhighlight %}

Please be advised that I passed two new arguments: `--no-total` and
`--flat`. The total is superfluous because we're only looking at
assets. Conversely, the total is valuable when you're looking at both assets and
liabilities. Subtracting them yields net worth<sup><a id="fnr.7" class="footref" href="#fn.7">7</a></sup>. And `--flat` is
purely aesthetic. It suppresses Ledger's automatic hierarchy view because it is
confusing when printing heterogenous commodities (such as currencies, stocks,
etc.).

This balance sheet matches our expectations but it isn't giving us much extra
information about each of the assets relative to each other&#x2014;value wise we're
comparing apples to oranges. Wouldn't it be nice to have all the assets
converted to one currency so we can compare apples to apples?

#### Implicit and explicit market prices

In order to compare values of assets we have to pick a base currency to convert
them to. I'm carrying a Dutch passport so my usual pick is to convert everything
to euros. But, as long as you supply Ledger the exchange rates, you could
express the value of your assets, even your guitar if you're so inclined, in
whatever commodity you like&#x2014;from Apple stock to real
apples<sup><a id="fnr.8" class="footref" href="#fn.8">8</a></sup>. Obviously your tools shouldn't stop you from expressing the
value of your guitar in apples that you pick from the tree! The only thing
Ledger needs is either an *implicit* or *explicit* market price.

We'll discuss prices in a moment. Before, to see the value of our assets
expressed in euros, we run the following command (adding `--exchange €`):

{% highlight bash %}
ledger -f postings3.dat b Assets --exchange € --no-total
{% endhighlight %}

Finally we have a birds eye view of all our assets's value across different
countries, accounts, and currencies:

How did Ledger convert evertyhing to euros? Ledger keeps track of prices
*implicitly* and also allows you to specify prices
manually---*explicitly*. Let's focus on the implicit part first, by asking
Ledger for the prices that it stored so far:

{% highlight bash %}
ledger -f postings3.dat prices
{% endhighlight %}

With this command you peek into Ledger's internal price database. The prices
that you see were established by the postings in `postings3.dat` and are all
*implicit*:

As a matter of experiment, let's say the price of Apple stock recently shot
up. It rose to an extent that we're now curious to see how much the value of our
US brokerage account increased. To find out, we're going to *explicitly* express
Apple's stock price in US dollars in a new file called `prices.dat`:

{% highlight ledger %}
P 2018-08-03 AAPL $ 207.99
{% endhighlight %}

The singe line in this file states: on `2018-08-03` the price for `AAPL` in `$`
was `207.99`. Let's make this file available to Ledger by specifying
`--price-db` and querying assets in the US (in which Apple belongs) only
(`Assets:US`):

{% highlight bash %}
ledger --file postings3.dat \
       balance Assets:US \
       --exchange € \
       --price-db prices.dat \
       --no-total
{% endhighlight %}

Indeed, we see the gains on Apple stock reflected by our increased total US
assets value. Apple stock got converted to US dollars got converted to euros:

You should add a line to `prices.dat` for every price that you want to track. I
personally have more than a thousand lines in my prices file and retrieve some
prices automatically using APIs (predominantly forex rates). The benefit of a
high resolution like that is that graphical plots of my assets, liabilities, and
net worth (using a daily interval on the x-axis) are less jumpy.

### Conclusion

To summarize, we've just created our first postings, discovered the implicit
exchange rates that Ledger keeps and added an Apple stock price explicitly. All
along the way we were able to query our balance in two representations: in its
original commodity and converted to one base currency.

**In part 2 we'll look at how you materialize an investment portfolio strategy
and asset allocation using Ledger.** Please leave your email adress if you want a
notification once it's published! I'd also love to hear your feedback about this
post and hear suggestions about topics that you'd like to see discussed in
depth. Reach out to me on Twitter: [@ppnlo](https://twitter.com/ppnlo). Or through email: replace the first
dot in the domain name with an @.

<!-- Begin MailChimp Signup Form -->
<link href="//cdn-images.mailchimp.com/embedcode/classic-10_7.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#mc_embed_signup{background:#fff; clear:left; font:14px Helvetica,Arial,sans-serif; }
	/* Add your own MailChimp form style overrides in your site stylesheet or in this style block.
	   We recommend moving this block and the preceding CSS link to the HEAD of your HTML file. */
</style>
<div id="mc_embed_signup">
<form action="https://epij.us19.list-manage.com/subscribe/post?u=359e0c2277a83d3411e823493&amp;id=dad6148db5" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
    <div id="mc_embed_signup_scroll">
	<h2>Feel free to subscribe: I'll notify you when publish the next part</h2>
<div class="indicates-required"><span class="asterisk">*</span> indicates required</div>
<div class="mc-field-group">
	<label for="mce-EMAIL">Email Address  <span class="asterisk">*</span>
</label>
	<input type="email" value="" name="EMAIL" class="required email" id="mce-EMAIL">
</div>
	<div id="mce-responses" class="clear">
		<div class="response" id="mce-error-response" style="display:none"></div>
		<div class="response" id="mce-success-response" style="display:none"></div>
	</div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
    <div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_359e0c2277a83d3411e823493_dad6148db5" tabindex="-1" value=""></div>
    <div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
    </div>
</form>
</div>
<script type='text/javascript' src='//s3.amazonaws.com/downloads.mailchimp.com/js/mc-validate.js'></script><script type='text/javascript'>(function($) {window.fnames = new Array(); window.ftypes = new Array();fnames[0]='EMAIL';ftypes[0]='email';fnames[1]='FNAME';ftypes[1]='text';fnames[2]='LNAME';ftypes[2]='text';fnames[3]='ADDRESS';ftypes[3]='address';fnames[4]='PHONE';ftypes[4]='phone';}(jQuery));var $mcj = jQuery.noConflict(true);</script>
<!--End mc_embed_signup-->

## Appendix

As always, this post is written in a literate
programming<sup><a id="fnr.9" class="footref" href="#fn.9">9</a></sup> style, which means that the code samples in
it are reproducible and correct. Check out the Org-mode and Babel source code on
GitHub: [real-world-ledger-part-1.org](https://raw.githubusercontent.com/pepijn/pepijn.github.io/master/org/real-world-ledger-part-1.org).

*Thank you Thomas Smolders, Pieter Levels and Arend Koopmans for helping me with
this post!*


# Footnotes

<sup><a id="fn.1" href="#fnr.1">1</a></sup> <https://www.ledger-cli.org/3.0/doc/ledger3.html>

<sup><a id="fn.2" href="#fnr.2">2</a></sup> <https://www.investopedia.com/terms/p/portfolio.asp>

<sup><a id="fn.3" href="#fnr.3">3</a></sup> [Eerlijke Bankwijzer: ASN Bank](https://eerlijkegeldwijzer.nl/bankwijzer/banken/asn-bank/)

<sup><a id="fn.4" href="#fnr.4">4</a></sup> Interest rates for ABN Amro savings accounts, similar
to other Dutch banks: <https://www.abnamro.nl/en/personal/savings/spaarrente.html>

<sup><a id="fn.5" href="#fnr.5">5</a></sup> [CBS inflation](http://statline.cbs.nl/StatWeb/publication/?VW=T&DM=SLNL&PA=70936NED&D1=0&D2=(l-34)-l&HD=081020-1258&HDR=T&STB=G1)

<sup><a id="fn.6" href="#fnr.6">6</a></sup> <https://www.ledger-cli.org/3.0/doc/ledger3.html#Explicit-posting-costs>

<sup><a id="fn.7" href="#fnr.7">7</a></sup> <https://en.wikipedia.org/wiki/Net_worth>

<sup><a id="fn.8" href="#fnr.8">8</a></sup> <https://www.ledger-cli.org/3.0/doc/ledger3.html#Posting-costs>

<sup><a id="fn.9" href="#fnr.9">9</a></sup> <https://en.wikipedia.org/wiki/Literate_programming>
