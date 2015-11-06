//
//  ScaleControllerObjC.m
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ScaleControllerObjC.h"
#import "ScaleController.h"

@interface ScaleControllerObjC ()
{
    ScaleController* wrapped;
}
@end

@implementation ScaleControllerObjC

- (id)init
{
    self = [super init];
    if (self)
    {
        wrapped = new ScaleController();
        if (!wrapped) self = nil;
    }
    return self;
}

- (bool)updateScaleFromJSON: (NSString*) jsonString
{
    const char* jsonChar = [jsonString UTF8String];
    if (!wrapped->updateScaleFromJSON (jsonChar))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithUTF8String: wrapped->errorMessage]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return false;
    }
    return true;
}

- (void)dealloc
{
    delete wrapped;
    [super dealloc]; // omit if using ARC
}

@end