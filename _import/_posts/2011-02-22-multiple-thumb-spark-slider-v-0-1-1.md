--- 
layout: post
title: Multiple thumb Spark Slider v. 0.1.1
created: 1298413416
---
<p>A new version of the multiple thumb Spark Slider is now available on <a title="pmowrer's Spark components at Github" href="https://github.com/pmowrer/spark-components" target="_blank">Github</a>. This version doesn't add any new major features, but polishes up existing behavior.&nbsp;Regrettably, I've had very little time to work on it since releasing the first version;&nbsp;I hope to get to adding new features soon enough. For now, see the change-list below for updates in version 0.1.1:</p><ul><li>Refactored HorizontalValueLayout and VerticalValueLayout into LinearValueLayout. This should enable easy creation of sliders between any two points, not just horizontal and vertical planes.&nbsp;
</li><li>Added element alignment to value layouts, enabling the Slider thumb to be positioned over its value in any way desired. Constants classes provide convenience values for layouts, used by the HSlider and VSlider classes.&nbsp;
</li><li>Renamed ThumbDragEvent to ThumbMouseEvent, and two if its types from BEGIN_DRAG and END_DRAG to PRESS and RELEASE respectively. This was done in order to be more consistent with the core Flex components and to better describe the event.&nbsp;
</li><li>Made ThumbMouseEvents bubble such that event listeners won't need to be added to individual thumbs, but can be listened to on the Slider component.</li></ul>
