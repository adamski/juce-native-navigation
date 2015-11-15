//
//  DataController.cpp
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#include "JuceHeader.h"
#include "DataController.h"
#include "MainComponent.h"
#include "Data.h"

/**
 * Methods to be called from Objective-C / Swift
 */

DataController::DataController()
{
}

const char* DataController::getJsonData()
{
    SharedResourcePointer<MainContentComponent> mainComponent;
    DBG (String(mainComponent->data.toJson().toRawUTF8()));
    return mainComponent->data.toJson().toRawUTF8();
}

const char* DataController::getTitle()
{
    SharedResourcePointer<MainContentComponent> mainComponent;
    return mainComponent->title.toRawUTF8();
}

void DataController::setMessage (const char *title, const char* message)
{
    SharedResourcePointer<MainContentComponent> mainComponent;
    mainComponent->title = (String) title;
    mainComponent->message = (String) message;
    mainComponent->repaint();
}

bool DataController::updateDataFromJson (const char* json)
{
    SharedResourcePointer<MainContentComponent> mainComponent;
    String jsonString = (String) json;
    Result result = mainComponent->data.updateFromJSON (jsonString);
    String errorMessage = String("Error loading data: " + result.getErrorMessage());
    
    if (result.failed())
    {
        errorMessage = result.getErrorMessage();
        return false;
    }
    
    DBG ("** JSON:: "+jsonString);
    
    return true;
}


