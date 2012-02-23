--- 
layout: post
title: "Part II: Using custom runners with Flash Builder 4's built-in FlexUnit4 support"
created: 1270003587
comments: true
disqus_identifier: node/8
---
Via asmock's [installation wiki](http://sourceforge.net/apps/mediawiki/asmock/index.php?title=Installation), I stumbled upon a second way to link a custom FlexUnit4 runner into a Flash Builder 4 project: using a compiler argument.

>Add the following to the "Additional compiler arguments" under "Flex Compiler" in your project properties:  
>-includes asmock.integration.flexunit.ASMockClassRunner

This way is probaby more straightforward than [using a custom FlexUnitApplication]({% post_url 2010-03-09-using-custom-runners-with-flash-builder-4s-built-in-flexunit4-support %}), at least as long as you're doing something simple.
