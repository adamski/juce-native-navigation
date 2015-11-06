//
//  ScaleController.h
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#ifndef JustTuner_ScaleController_h
#define JustTuner_ScaleController_h

/*
 #import <Foundation/Foundation.h>
 
 @interface ObjcObject : NSObject
 - (void)exampleMethodWithString:(NSString*)str;
 // other wrapped methods and properties
 @end
 
*/

struct ScaleController
{
    ScaleController();
    bool updateScaleFromJSON (const char* json);
    //void playNote (int noteNumber);
    const char* errorMessage;
    
};

#endif
