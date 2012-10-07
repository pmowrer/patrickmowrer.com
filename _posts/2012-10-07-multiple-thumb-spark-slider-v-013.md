--- 
layout: post
title: Multiple thumb Spark Slider v. 0.1.3.
comments: true
---

Some way-overdue bug fixes have been made to the multiple-thumb Spark slider component. Thanks to those reporting issues! Please let me know if there's anything else that needs fixing; promise it won't take another year. Find the new version on [Github](http://github.com/pmowrer/spark-components "pmowrer's spark-components at master - GitHub"). Change list for version 0.1.3 below:<!--break-->

* Fixed bug giving thumbs NaN value when min and max are set to same value.
* Fixed bug where setting minimum and maximum at same time could limit either based on previous minimum/maximum value.
* Fixed bug where clicking on track in a negative value range would cause null exception.
