//
//  iosMainWindow.h
//  iosNavigation
//
//  Created by Adam Wilson on 30/08/2015.
//
//

#ifndef iosNavigation_iosMainWindow_h
#define iosNavigation_iosMainWindow_h

#include "../JuceLibraryCode/JuceHeader.h"


class MainWindow    : public DocumentWindow
{
public:
    MainWindow (String name);
    void closeButtonPressed() override;
    static void addComponentToUIView (Component& comp, void* uiView);
    
private:
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MainWindow)
};

#endif
