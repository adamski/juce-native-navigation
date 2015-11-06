//
//  ScaleControllerObjC.h
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#import <Foundation/Foundation.h>

@interface ScaleControllerObjC : NSObject

/** Call ScaleController with JSON to update the current Scale object */
- (bool)updateScaleFromJSON: (NSString*) jsonString;

@end
