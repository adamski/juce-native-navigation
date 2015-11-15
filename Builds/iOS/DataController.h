//
//  DataController.h
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#ifndef JustTuner_DataController_h
#define JustTuner_DataController_h

/** 
 * Methods to expose to Objective-C
 * Note that only basic C types are exposed
 */

struct DataController
{
    DataController();
    /** Set message and repaint MainContentComponent */
    void setMessage (const char *title, const char* message);
    /** Get current title from MainContentComponent */
    const char* getTitle();
    /** Get JSON string of all message data */
    const char* getJsonData();
    /** Update data from JSON string */
    bool updateDataFromJson (const char* json);
    const char* errorMessage;
};

#endif
