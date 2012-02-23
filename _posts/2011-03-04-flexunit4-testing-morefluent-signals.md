--- 
layout: post
title: FlexUnit4-testing with morefluent-signals
created: 1299275143
comments: true
disqus_identifier: node/14 
---

Some time ago I wrote about [improving the readability of asynchronous FlexUnit4 tests]({% post_url 2010-08-19-improving-readability-of-asynchronous-tests-in-flexunit4-using-hamcrest-matchers %} "Improving readability of asynchronous tests in FlexUnit4 using Hamcrest matchers"), which typically suffer from being broken up on multiple function blocks and from the terse method names of the `Async` helper class. To address it, I wrote a [library of asynchronous
matchers](https://github.com/pmowrer/hamcrest-as3-async) intended to be used with [hamcrest-as3](https://github.com/drewbourne/hamcrest-as3 "hamcrest-as3").

Soon thereafter, I was made aware of the existence of Kris Karczmarczyk's excellent library [morefluent](https://bitbucket.org/loomis/morefluent/wiki/Home "morefluent"), already addressing all of the issues I aimed to correct in my own library, and more. It has since become one of the swcs I always drop into my libs folder when I start a test project, along with other givens like hamcrest-as3 and FlexUnit4. Quite frankly, its a disgrace this library has only been downloaded some 60 or so times across its version history (according to BitBucket's stats), but that probably says more about the prevalence of unit testing within the Flex/Flash community than anything else.<!--break-->

For my latest project, I've almost exclusively moved over to using as3-signals over Flash's native events. However, morefluent only works with events, and there isn't much in the way of alternatives. There's a library wrapping FlexUnit4's `Async` for use with as3-signals, [as3-signals-utilities-async](https://github.com/eidiot/as3-signals-utilities-async/ "as3-signals-utilities-async"), enabling asynchronous signal testing, but writing tests with it is no different than
using regular `Async`; the readability issues remain (by design, of course). Sacrificing test readability not being an option, I decided to marry morefluent with as3-signals-utilities-async, creating [morefluent-signals](https://github.com/pmowrer/morefluent-signals "morefluent-signals").

To illustrate my point, this is how the first example from [as3-signals-utilities-readme](https://github.com/eidiot/as3-signals-utilities-async/blob/master/README.textile "as3-signals-utilities-async README.textile") reads:

{% highlight as3 %}
[Test(async)]
public function change_user():void
{
    var model:IModel = new SomeModel();
    handleSignal(this, model.changedSignal, verify_user, 500,  
        {name:"Tom", age:20});
    model.changeUser("Tom", 20);
}

private function verify_user(event:SignalAsyncEvent, data:Object):void
{
    assertEquals(event.args[ 0 ], data.name);
    assertEquals(event.args[ 1 ], data.age);
}
{% endhighlight %}

This is how the same example reads with morefluent-signals:

{% highlight as3 %}
[Test(async)]
public function change_user():void
{
    var model:IModel = new SomeModel();
    model.changeUser("Tom", 20);
    after(model.changedSignal).assertOnArguments().equals(["Tom", 20]);
}
{% endhighlight %}

Here are a few more examples of how you can use morefluent-signals to assert that...

... an asynchronous signal was never dispatched:

{% highlight as3 %}
[Test(async)]
public function asyncSignalWasNeverDispatched():void
{
    after(asyncSignal).fail();
}
{% endhighlight %}

... an asynchronous signal was dispatched with given arguments:

{% highlight as3 %}
[Test(async)]
public function asynchSignalWasDispatchedWithArgs():void
{
    after(asyncSignal).assertOnArguments().equals([anything()]);
}
{% endhighlight %}

... a synchronous singal was dispatched x number of times:

{% highlight as3 %}
[Test]
public function syncSignalWasDispatchedTwice():void
{
    observing(syncSignal);
    syncSignal.dispatch();
    syncSignal.dispatch();
    assert(syncSignal).dispatched(times(2));
}
{% endhighlight %}

... a synchronous signal was dispatched with given arguments:

{% highlight as3 %}
[Test]
public function syncSignalWasDispatchedWithArguments():void
{
    observing(syncSignal);
    syncSignal.dispatch("string", 123);
    assert(syncSignal).dispatched(withArguments("string", 123));
}
{% endhighlight %}

Download [morefluent-signals on Github](https://github.com/pmowrer/morefluent-signals "morefluent-signals") and let me know what you think. I'm more than happy to address any issues you come across or considering any new features that makes your testing easier.
