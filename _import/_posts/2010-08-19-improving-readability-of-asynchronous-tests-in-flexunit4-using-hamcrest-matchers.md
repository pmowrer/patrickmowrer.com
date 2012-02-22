--- 
layout: post
title: Improving readability of asynchronous tests in FlexUnit4 using Hamcrest matchers
created: 1282241082
---
<p>Inspired by the book <a title="Growing Object-Oriented Software, Guided by Tests at Amazon.com" href="http://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627" target="_blank">Growing Object-Oriented Software, Guided by Tests</a>, I've been working on improving how well my AS3/Flex tests read, both in terms of the test code itself as well as the diagnostics, the error description of failed tests. The goal is to make tests read more like plain English and, most importantly, better convey their intent. To this end, the <a title="Hamcrest at Google Code" href="http://code.google.com/p/hamcrest/" target="_blank">Hamcrest</a> library is excellent, providing matchers to make test code more expressive and expectations and errors more descriptive. Thankfully, Hamcrest has been around for some time for AS3, <a title="drewbourne's hamcrest-as3 at Github.com" href="http://github.com/drewbourne/hamcrest-as3" target="_blank">ported from Java by Drew Bourne</a>.</p><p>After applying many of the techniques found in the book, I still found my tests lacking readibility when making assertions on asynchronous behavior. <a title="FlexUnit4: Writing an AsyncTest" href="http://docs.flexunit.org/index.php?title=Writing_an_AsyncTest" target="_blank">FlexUnit4 allows for asynchronous testing</a> of events with the help of the Async class, and while the functionality is good, the tests generally don't read so well. Bitten by the Hamcrest-matcher-writing bug, I decided to wrap the behavior of the Async class in Hamcrest matchers, creating a <a title="pmowrer's hamcrest-as3-async at GitHub.com" href="http://github.com/pmowrer/hamcrest-as3-async/" target="_blank">hamcrest-as3-async library</a>. Though this may be stretching the definition of a matcher, I like what I've come up with thus far. Here are a few before-and-after examples to consider:<!--break--></p><h3>Event dispatchment</h3><p>Even such a simple test as determining wheter an event has been dispatched doesn't read anything like the fairly descriptive name of the test (i.e. the function name):</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function dispatchesAnEventOfTypeTest():void
{
   Async.proceedOnEvent(this, dispatcher, "test");

   dispatcher.dispatchEvent(new Event("test"));
}{/syntaxhighlighter}</p><p>Should it fail, Async's error description isn't overly informative: <cite></cite></p><blockquote><p>Error: Timeout Occurred before expected event.</p></blockquote><p>Alright, maybe I'm getting picky here, but we can do better. Instead, using a Hamcrest matcher:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function dispatchesAnEventOfTypeTest():void
{
   assertAsynchronouslyThat(dispatcher, dispatchesEventOfType("test"), this);

   dispatcher.dispatchEvent(new Event("test"));
}{/syntaxhighlighter}</p><p>The test now reads more like the name of the test. Should it fail, it also does so more informatively:</p><blockquote><p>Error: Expected: Event of type "test" was dispatched<br>but: Event of type "test" wasn't dispatched (timed out after &lt;500&gt; ms)</p></blockquote><p>As you can see, the length of the timeout is mentioned in the error description, a value Async allows you to customize. Using a chained method call, <code>beforeTimeoutAt</code>, I've made it applicable to the matcher as well. The following sets the timeout to 1000 ms (instead of 500 ms by default):</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }assertAsynchronouslyThat(dispatcher, dispatchesEventOfType("test")
   .beforeTimeoutAt(1000), this);{/syntaxhighlighter}</p><h3>Quirks</h3><p>Before we go further, a couple of quick gotchas: </p><ol><li>Like the Async class and unlike regular Hamcrest matchers, an asynchronous matcher must be declared before the event it listens for is dispatched. </li><li>You may not have noticed, but the last argument passed to <code>assertAsynchronouslyThat</code> is <code>this</code>. It must be passed an instance of the test case it is executing in as Async depends on that information. This is a bit ugly and surely a potential source of errors as it is easily forgotten and left off. <del></del>Unfortunately, I'm currently not aware of a way around this.<ins></ins><ins></ins></li></ol><h3>Event data</h3><p>Asserting on event data with Async is when readability really starts to suffer. A callback is required, forcing the test code to be broken up into two blocks. This means assertions are often being made in a second, separate function block, making the flow of the test difficult to follow. This can be remedied somewhat by nesting functions, but readability is still poor: </p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function dispatchesAnEventOfTypeTestWithData():void
{
   Async.handleEvent(this, dispatcher, "test", assertDataIsEqualToValue);

   function assertDataIsEqualToValue(event:DataEvent, data:Object):void
   {
      assertThat(event, hasProperty("data", equalTo("value")));
   }   

   dispatcher.dispatchEvent(new DataEvent("test", false, false, "value"));
}{/syntaxhighlighter}</p><p>The following is an identical test, only it's written declaratively using an asynchronous Hamcrest matcher:</p><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function dispatchesAnEventOfTypeTestWithData():void
{
   assertAsynchronouslyThat(dispatcher, dispatchesEventOfType("test")
      .which(hasProperty("data", equalTo("value"))),this);

   dispatcher.dispatchEvent(new DataEvent("test", false, false, "value"));
}{/syntaxhighlighter}</p><p>Using the chained <code>which</code> method call, regular Hamcrest matchers can be added to match against the dispatched event.</p><h3>Signals</h3><p><a title="AS3 Signals at GitHub.com" href="http://www.github.com/robertpenner/as3-signals" target="_blank">Robert Penner's AS3 Signals</a> have become a popular alternative to the AS3 event system. With the help of the <a title="AS3 Signals Utilities Async at GitHub.com" href="http://www.github.com/eidiot/as3-signals-utilities-async/" target="_blank">Signal-Async wrapper library</a>, asynchronous matchers do Signals too!</p><h4>Asserting on Signal dispatchment</h4><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function dispatchesASignal():void
{
   assertAsynchronouslyThat(signalDispatcher, dispatchesSignal(), this);

   signalDispatcher.dispatch();
}{/syntaxhighlighter}</p><h4>Asserting on Signal arguments</h4><p>{syntaxhighlighter brush: as3;fontsize: 100; first-line: 1; }[Test(async)]
public function dispatchesASignalWithSpecificArguments():void
{  
   assertAsynchronouslyThat(signalDispatcher, dispatchesSignal()
      .which(hasArguments("value", 123)), this);

   signalDispatcher.dispatch("value", 123);
}{/syntaxhighlighter}</p><h3>The code</h3><p>Asynchronous matching is only an experiment I've been making use of in my own projects. If you're interested in it, <a title="pmowrer's hamcrest-as3-async at GitHub.com" href="http://github.com/pmowrer/hamcrest-as3-async/" target="_blank">please check it out on github</a>. Please note that it depends on the most recent <a title="drewbourne's hamcrest-as3 at Github.com" href="http://www.github.com/drewbourne/hamcrest-as3" target="_blank">hamcrest-as3 code</a> and isn't compatible with its most recent SWC release, 1.0.2.</p>
