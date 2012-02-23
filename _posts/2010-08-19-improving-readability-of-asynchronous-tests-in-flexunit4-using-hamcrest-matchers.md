--- 
layout: post
title: Improving readability of asynchronous tests in FlexUnit4 using Hamcrest matchers
created: 1282241082
comments: true
disqus_identifier: node/11
---
Inspired by the book [Growing Object-Oriented Software, Guided by Tests](http://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627 "Growing Object-Oriented Software, Guided by Tests at Amazon.com"), I've been working on improving how well my AS3/Flex tests read, both in terms of the test code itself as well as the diagnostics, the error description of failed tests. The goal is to make tests read more like plain English and, most importantly, better
convey their intent. To this end, the [Hamcrest](http://code.google.com/p/hamcrest/ "Hamcrest at Google Code") library is excellent, providing matchers to make test code more expressive and expectations and errors more descriptive. Thankfully, Hamcrest has been around for some time for AS3, [ported from Java by Drew Bourne](http://github.com/drewbourne/hamcrest-as3 "drewbourne's hamcrest-as3 at Github.com").

After applying many of the techniques found in the book, I still found my tests lacking readibility when making assertions on asynchronous behavior. [FlexUnit4 allows for asynchronous testing](http://docs.flexunit.org/index.php?title=Writing_an_AsyncTest "FlexUnit4: Writing an AsyncTest") of events with the help of the Async class, and while the functionality is good, the tests generally don't read so well. Bitten by the Hamcrest-matcher-writing bug, I decided to wrap the
behavior of the Async class in Hamcrest matchers, creating a [hamcrest-as3-async library](http://github.com/pmowrer/hamcrest-as3-async/ "pmowrer's hamcrest-as3-async at GitHub.com"). Though this may be stretching the definition of a matcher, I like what I've come up with thus far. Here are a few before-and-after examples to consider:<!--break-->

###Event dispatchment###
Even such a simple test as determining wheter an event has been dispatched doesn't read anything like the fairly descriptive name of the test (i.e. the function name):

{% highlight as3 %}
[Test(async)]
public function dispatchesAnEventOfTypeTest():void
{
   Async.proceedOnEvent(this, dispatcher, "test");

   dispatcher.dispatchEvent(new Event("test"));
}
{% endhighlight %}

Should it fail, Async's error description isn't overly informative:

>Error: Timeout Occurred before expected event.

Alright, maybe I'm getting picky here, but we can do better. Instead, using a Hamcrest matcher:

{% highlight as3 %}
[Test(async)]
public function dispatchesAnEventOfTypeTest():void
{
   assertAsynchronouslyThat(dispatcher, dispatchesEventOfType("test"), this);

   dispatcher.dispatchEvent(new Event("test"));
}
{% endhighlight %}

The test now reads more like the name of the test. Should it fail, it also does so more informatively:

>Error: Expected: Event of type "test" was dispatched but: Event of type "test" wasn't dispatched (timed out after &lt;500&gt; ms)

As you can see, the length of the timeout is mentioned in the error description, a value Async allows you to customize. Using a chained method call, `beforeTimeoutAt`, I've made it applicable to the matcher as well. The following sets the timeout to 1000 ms (instead of 500 ms by default):

{% highlight as3 %}
assertAsynchronouslyThat(dispatcher, dispatchesEventOfType("test")
   .beforeTimeoutAt(1000), this);
{% endhighlight %}

###Quirks###
Before we go further, a couple of quick gotchas: 
1. Like the Async class and unlike regular Hamcrest matchers, an asynchronous matcher must be declared before the event it listens for is dispatched. 
2. You may not have noticed, but the last argument passed to `assertAsynchronouslyThat` is `this`. It must be passed an instance of the test case it is executing in as Async depends on that information. This is a bit ugly and surely a potential source of errors as it is easily forgotten and left off. Unfortunately, I'm currently not aware of a way around this.

###Event data###
Asserting on event data with Async is when readability really starts to suffer. A callback is required, forcing the test code to be broken up into two blocks. This means assertions are often being made in a second, separate function block, making the flow of the test difficult to follow. This can be remedied somewhat by nesting functions, but readability is still poor:

{% highlight as3 %}
[Test(async)]
public function dispatchesAnEventOfTypeTestWithData():void
{
   Async.handleEvent(this, dispatcher, "test", assertDataIsEqualToValue);

   function assertDataIsEqualToValue(event:DataEvent, data:Object):void
   {
      assertThat(event, hasProperty("data", equalTo("value")));
   }

   dispatcher.dispatchEvent(new DataEvent("test", false, false, "value"));
}
{% endhighlight %}

The following is an identical test, only it's written declaratively using an asynchronous Hamcrest matcher:

{% highlight as3 %}
[Test(async)]
public function dispatchesAnEventOfTypeTestWithData():void
{
   assertAsynchronouslyThat(dispatcher, dispatchesEventOfType("test")
      .which(hasProperty("data", equalTo("value"))),this);

   dispatcher.dispatchEvent(new DataEvent("test", false, false, "value"));
}
{% endhighlight %}

Using the chained `which` method call, regular Hamcrest matchers can be added to match against the dispatched event.

###Signals###
[Robert Penner's AS3 Signals](http://www.github.com/robertpenner/as3-signals "AS3 Signals at GitHub.com") have become a popular alternative to the AS3 event system. With the help of the [Signal-Async wrapper library](http://www.github.com/eidiot/as3-signals-utilities-async/ "AS3 Signals Utilities Async at GitHub.com"), asynchronous matchers do Signals too!

####Asserting on Signal dispatchment####
{% highlight as3 %}
[Test(async)]
public function dispatchesASignal():void
{
   assertAsynchronouslyThat(signalDispatcher, dispatchesSignal(), this);

   signalDispatcher.dispatch();
}
{% endhighlight %}

####Asserting on Signal arguments####
{% highlight as3 %}
[Test(async)]
public function dispatchesASignalWithSpecificArguments():void
{
   assertAsynchronouslyThat(signalDispatcher, dispatchesSignal()
      .which(hasArguments("value", 123)), this);

   signalDispatcher.dispatch("value", 123);
}
{% endhighlight %}

###The code###
Asynchronous matching is only an experiment I've been making use of in my own projects. If you're interested in it, [please check it out on github](http://github.com/pmowrer/hamcrest-as3-async/ "pmowrer's hamcrest-as3-async at GitHub.com"). Please note that it depends on the most recent [hamcrest-as3 code](http://www.github.com/drewbourne/hamcrest-as3 "drewbourne's hamcrest-as3 at Github.com") and isn't compatible with its most recent SWC release, 1.0.2.
