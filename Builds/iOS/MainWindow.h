//
//  MainWindow.h
//  iosNavigation
//
//  Created by Adam Elemental on 30/08/2015.
//
//

#ifndef iosNavigation_MainWindow_h
#define iosNavigation_MainWindow_h

#include "../JuceLibraryCode/JuceHeader.h"
#include "MainComponent.h"

class MainWindow    : public DocumentWindow
{
public:
    MainWindow (String name)  : DocumentWindow (name,
                                                Colours::lightgrey,
                                                DocumentWindow::allButtons)
    {
        setUsingNativeTitleBar (true);
        setContentOwned (new MainContentComponent(), true);
        
#if JUCE_ANDROID
        setFullScreen (true);
#else
        setResizable (true, true);
#endif
    }
    
    void closeButtonPressed() override
    {
        // This is called when the user tries to close this window. Here, we'll just
        // ask the app to quit when this happens, but you can change this to do
        // whatever you need.
        JUCEApplication::getInstance()->systemRequestedQuit();
    }
    
    /* Note: Be careful if you override any DocumentWindow methods - the base
     class uses a lot of them, so by overriding you might break its functionality.
     It's best to do all your work in your content component instead, but if
     you really have to override any DocumentWindow methods, make sure your
     subclass also calls the superclass's method.
     */
    
private:
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MainWindow)
};



#endif
