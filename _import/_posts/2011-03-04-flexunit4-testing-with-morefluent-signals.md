--- 
layout: post
title: FlexUnit4-testing with morefluent-signals
created: 1299275143
---
<p>Some time ago I wrote about&nbsp;<a title="Improving readability of asynchronous tests in FlexUnit4 using Hamcrest matchers" href="http://patrickmowrer.com/2010/08/19/improving-readability-of-asynchronous-tests-in-flexunit4-using-hamcrest-matchers" target="_blank">improving the readability of asynchronous FlexUnit4 tests</a>, which typically suffer from being broken up on multiple function blocks and from the terse method names of the <code>Async</code> helper class. To address it, I wrote a <a href="https://github.com/pmowrer/hamcrest-as3-async" target="_blank">library of asynchronous matchers</a> intended to be used with <a title="hamcrest-as3" href="https://github.com/drewbourne/hamcrest-as3" target="_blank">hamcrest-as3</a>. </p><p>Soon thereafter, I was made aware of the existence of Kris Karczmarczyk's excellent library <a title="morefluent" href="https://bitbucket.org/loomis/morefluent/wiki/Home" target="_blank">morefluent</a>, already addressing all of the issues I aimed to correct in my own library, and more. It has since become one of the swcs I always drop into my libs folder when I start a test project, along with other givens like hamcrest-as3 and FlexUnit4. Quite frankly, its a disgrace this library has only been downloaded some 60 or so times across its version history (according to BitBucket's stats), but that probably says more about the prevalence of unit testing within the Flex/Flash community than anything else.<!--break-->

</p><p>For my latest project, I've almost exclusively moved over to using as3-signals over Flash's native events. However, morefluent only works with events, and there isn't much in the way of alternatives. There's a library wrapping FlexUnit4's <code>Async</code> for use with as3-signals, <a title="as3-signals-utilities-async" href="https://github.com/eidiot/as3-signals-utilities-async/" target="_blank">as3-signals-utilities-async</a>, enabling asynchronous signal testing, but writing tests with it is no different than using regular <code>Async</code>&nbsp;-- the readability issues remain&nbsp;(by design, of course). Sacrificing test readability not being an option, I decided to marry morefluent with as3-signals-utilities-async, creating <a title="morefluent-signals" href="https://github.com/pmowrer/morefluent-signals" target="_blank">morefluent-signals</a>. </p><p>To illustrate my point, this is how the first example from&nbsp;<a title="as3-signals-utilities-async README.textile" href="https://github.com/eidiot/as3-signals-utilities-async/blob/master/README.textile" target="_blank">as3-signals-utilities-async's readme</a> reads:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)] 
public function change_user():void 
{
    var model:IModel = new SomeModel();
    handleSignal(this, model.changedSignal, verify_user, 500, {name:"Tom", age:20});
    model.changeUser("Tom", 20);
}

private function verify_user(event:SignalAsyncEvent, data:Object):void 
{
    assertEquals(event.args[ 0 ], data.name);
    assertEquals(event.args[ 1 ], data.age);
}{/syntaxhighlighter}</p><p>This is how the same example reads with morefluent-signals:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)] 
public function change_user():void 
{
    var model:IModel = new SomeModel();
    model.changeUser("Tom", 20);
    after(model.changedSignal).assertOnArguments().equals(["Tom", 20]);
}{/syntaxhighlighter}</p><p>Here are a few more examples of how you can use morefluent-signals to assert that...</p><p>... an asynchronous signal was never dispatched:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function asyncSignalWasNeverDispatched():void
{
    after(asyncSignal).fail();
}&nbsp;{/syntaxhighlighter}</p><p>... an asynchronous signal was dispatched with given arguments:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function asynchSignalWasDispatchedWithArgs():void
{
    after(asyncSignal).assertOnArguments().equals([anything()]);
}&nbsp;{/syntaxhighlighter}</p><p>... a synchronous singal was dispatched x number of times:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test]
public function syncSignalWasDispatchedTwice():void
{
    observing(syncSignal);
    syncSignal.dispatch();
    syncSignal.dispatch();
    assert(syncSignal).dispatched(times(2));
}{/syntaxhighlighter}</p><p>... a synchronous signal was dispatched with given arguments:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test]
public function syncSignalWasDispatchedWithArguments():void
{
    observing(syncSignal);
    syncSignal.dispatch("string", 123);
    assert(syncSignal).dispatched(withArguments("string", 123));
}{/syntaxhighlighter}</p>

<p>Download <a title="morefluent-signals" href="https://github.com/pmowrer/morefluent-signals" target="_blank">morefluent-signals on Github</a> and let me know what you think. I'm more than happy to address any issues you come across or considering any new features that makes your testing easier.</p>
