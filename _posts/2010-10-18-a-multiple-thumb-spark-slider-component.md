--- 
layout: post
title: A multiple thumb Spark Slider component
created: 1287453476
comments: true
disqus_identifier: node/12 
---

After coming across a [few](http://forums.adobe.com/message/3063304 "Multiple thumbs in hslider for flex4") community [requests](http://stackoverflow.com/questions/2677822 "Flex 4 Slider with two thumbs") for a Spark Slider component with multiple thumbs, I decided building one would be a nice little side-project, perhaps with the added bonus of improving on my understanding of the Spark component architecture in the process. After all, how hard could it be? It's just another couple of thumbs, right?

Turns out it wasn't quite as easy as I had imagined, perhaps the reason there isn't already a few of these floating around out there (or is there?). The Spark Slider is a nice component, but also a beast with a long inheritance chain (`SkinnableComponent` -&gt; `Range` -&gt; `TrackBase` -&gt; `SliderBase`) and tightly coupled skin parts. `Range` is nothing but logic and would be a nice utility to make use of; sadly it inherits from `SkinnableComponent`. The layout is inexplicably baked into `HSlider` and `VSlider`, making it impossible to add any behavior up the inheritance chain without the need to re-create those classes (copy/paste, of course, just like skins!).

That said, perhaps there's a good reason the original Spark component was written in that fashion. Either way, the implementation of this new Slider takes a lot of the existing Spark Slider code, cleans it up some and factors it out into more manageable bits. Layout is handled by a `ValueLayout` implementation, making it possible to create, for example, a `CircularSlider` without having to extend `SliderBase`. Some of the Halo Slider behavior is also there, like `allowOverlap`, and some isn't, like having both `value` and `values` properties. I think it's a good start, but I'll let you be the judge. Check out the live comparison between the new Slider and those of Halo and Spark below.

<div id="sliders">
</div>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js">
</script>
<script type="text/javascript">
    swfobject.embedSWF("/swf/sliders-demo/Sliders.swf", "sliders", "550", "650", "10.0.0"); 
</script>

##Usage##
As you'd expect, there are `HSlider` and `VSlider` convenience classes available. Neither define any logic, but are simply placeholders for a couple of style properties. For example, `HSlider` is equivalent to:

{% highlight as3 %}
<ns:SliderBase skinClass="com.patrickmowrer.skins.HSliderSkin"  
dataTipOffsetY="-25" />;
{% endhighlight %}

The docs are currently absent, but hopefully it should be straightforward enough as I've tried to mimic desirable behaviors of the Halo and Spark components. From there, I intend to add additional functionality like [Doug McCune's Draggable Slider](http://dougmccune.com/blog/2007/01/21/draggable-slider-component-for-flex/ "Draggable Slider Component for Flex"). For now, please feel free to download the component from the [Github repository](http://github.com/pmowrer/spark-components "pmowrer's spark-components at master - GitHub") and let me know of any questions/issues.
