--- 
layout: post
title: "Part II: Using custom runners with Flash Builder 4's built-in FlexUnit4 support"
created: 1270003587
---
<p>Via asmock's <a href="http://sourceforge.net/apps/mediawiki/asmock/index.php?title=Installation">installation wiki</a>, I stumbled upon a second way to link a custom FlexUnit4 runner into a Flash Builder 4 project: using a compiler argument.</p><blockquote><p> Add the following to the "Additional compiler 
arguments" under "Flex Compiler" in your project properties:<br>-includes
 asmock.integration.flexunit.ASMockClassRunner</p></blockquote><p>This way is probaby more straightforward than <a href="http://www.patrickmowrer.com/2010/03/09/using-custom-runners-flash-builder-4s-built-flexunit4-support">using a custom FlexUnitApplication</a>, at least as long as you're doing something simple.<!--break--></p>
