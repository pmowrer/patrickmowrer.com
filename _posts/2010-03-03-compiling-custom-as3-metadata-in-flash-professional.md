--- 
layout: post
title: Compiling custom AS3 metadata in Flash Professional
created: 1267645901
comments: true
---
The use of custom metadata tags is becoming more commonplace in frameworks and libraries developed for the Flash platform. While many are targeted specifically for use with Flex and, by extension, the mxmlc compiler, others have uses outside of Flex. An example is [FlexUnit4][], which despite its name is easily used for testing&nbsp;AS3-only projects. Other testing frameworks that want to play nice with FlexUnit4, such as [mock-as3][] and [flex-mockito][], have incorporated custom metadata as well.

The mxmlc compiler accepts custom metadata with a command line option: *keep-as3-metadata*. As of Flex Builder 3 (mxmlc 3.0), custom metadata can be integrated seamlessly, rendering the additional option unnecessary most of the time. However, if you aren't using the mxmlc compiler to compile your AS3 project, you may find that you also aren't able to use custom metadata. For example, if you attempt to compile a FlexUnit4 test case in Flash Professional, you encounter an unexpected error:

>initializationError Error: No runnable methods at org.flexunit.runners::BlockFlexUnit4ClassRunner/validateInstanceMethods()

The Flash Pro compiler does support some metadata tags, like **SWF** and **Embed**, but not custom tags that FlexUnit4 relies on, such as **Test**. <!--break-->As a result, all unrecognized tags are thrown out during compilation, in this example stripping the FlexUnit4 test case of any and all **Test** tags. When FlexUnit4 then attempts to run the test case, it finds nothing to run, throwing the error above.

As far as I know, Flash Pro doesn't let you add command-line arguments to its compiler, but the good news is that there is a simple workaround to this problem, albeit a subtle one. By checking "**Export SWC**" in the "Publish Settings" dialog, all custom metadata is left alone during compilation.

<img src="/images/export_swc.preview.png" alt="" height="104" width="555">

[FlexUnit4]: http://docs.flexunit.org/index.php?title=Main_Page "FlexUnit4"
[mock-as3]: http://code.google.com/p/mock-as3/ "mock-as3"
[flex-mockito]: http://bitbucket.org/loomis/mockito-flex/wiki/Home "flex-mockito"
