//
//  iosMainWindow.h
//  JustTuner
//
//  Created by Adam Wilson on 30/08/2015.
//
//

#ifndef JustTuner_iosMainWindow_h
#define JustTuner_iosMainWindow_h

#include "../JuceLibraryCode/JuceHeader.h"
#include "MainComponent.h"


//==============================================================================
/*
 This class implements the iOS window that contains an instance of
 our MainContentComponent class.
 
 */

class MainWindow    : public DocumentWindow
{
public:
    MainWindow (String name);
    void closeButtonPressed() override;
    static void addComponentToUIView (Component& comp, void* uiView);
    
private:
    SharedResourcePointer<MainContentComponent> mainComponent;
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (MainWindow)
};

#endif
