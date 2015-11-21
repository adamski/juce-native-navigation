# juce-native-navigation
##JUCE iOS and Android example project to show mixing of native API's with JUCE Components. 

The idea is to show how to mix native UI elements and pass data to and from C++ and native UI code. 

The example app shows a list of random messages with titles stored as JSON in the `MainComponent` class. The JSON data is used by both Android and iOS UI classes to populate a list. When the user selects an item title from the list, the corresponding message is sent to the `MainComponent` class for display.  

In iOS a UINavigationController is used to navigate between JUCE and an iOS UITableView.
For Android a NavigationDrawer is used to bring up a list of items. 

This project was written as part of a talk given at the JUCE Summit 2015 (20th November 2015).

See the PDF file for slides from the talk. 
