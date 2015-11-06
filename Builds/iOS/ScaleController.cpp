//
//  ScaleController.cpp
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#include "JuceHeader.h"
#include "ScaleController.h"
#include "Scale.h"
#include "SharedObjects.h"


ScaleController::ScaleController()
{
}

bool ScaleController::updateScaleFromJSON (const char* json)
{
    SharedResourcePointer<SharedObjects> sharedObjects;
    String jsonString = (String) json;
    Result result = sharedObjects->scale.updateFromJSON (jsonString);
    String errorMessage = String("Error loading scale: " + result.getErrorMessage());
    
    if (result.failed())
    {
        errorMessage = result.getErrorMessage();
        return false;
    }
    
    DBG ("** JSON:: "+jsonString);
    
    return true;
}

//void playNote(int noteNumber)
//{   
//    SharedResourcePointer<SharedObjects> sharedObjects;
//    sharedObjects->keyboardState.noteOn (sharedObjects->defaultMidiChannel, noteNumber, sharedObjects->defaultVelocity);
//}
