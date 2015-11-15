//
//  DataControllerObjC.m
//  JustTuner
//
//  Created by Adam Elemental on 17/09/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataControllerObjC.h"
#import "DataController.h"

@interface DataControllerObjC ()
{
    DataController* wrapped;
}
@end

@implementation DataControllerObjC

- (id)init
{
    self = [super init];
    if (self)
    {
        wrapped = new DataController();
        if (!wrapped) self = nil;
    }
    return self;
}

- (void)setMessage: (NSString*) title :(NSString*) message
{
    const char* titleChar   = [title UTF8String];
    const char* messageChar = [message UTF8String];
    wrapped->setMessage(titleChar, messageChar);
}

- (NSString*)getTitle
{
    NSString* titleString = [ NSString stringWithUTF8String:wrapped->getTitle() ];
    return titleString;
}

- (NSString*)getJsonData
{
    const char* jsonCharPointer = wrapped->getJsonData();
//    NSString* jsonDataString = [ NSString stringWithUTF8String: jsonCharPointer];
    NSString* jsonDataString = [ NSString stringWithFormat:@"%s", jsonCharPointer];
//    NSLog(@"jsonDataString == %@",jsonDataString);
    return jsonDataString;
}

- (bool)updateDataFromJson: (NSString*) jsonString
{
    const char* jsonChar = [jsonString UTF8String];
    if (!wrapped->updateDataFromJson (jsonChar))
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