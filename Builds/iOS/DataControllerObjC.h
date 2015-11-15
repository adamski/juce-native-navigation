//
//  DataControllerObjC.h
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#import <Foundation/Foundation.h>

@interface DataControllerObjC : NSObject

/** Set message and repaint JUCE MainContentComponent */
- (void)setMessage: (NSString*) title :(NSString*) message;
/** Get current title from MainContentComponent */
- (NSString*)getTitle;
/** Get Data as JSON String */
- (NSString*)getJsonData;
/** Call DataController with JSON to update the current Data object */
- (bool)updateDataFromJson: (NSString*) jsonString;

@end
