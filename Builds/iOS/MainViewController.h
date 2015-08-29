//
//  MainViewController.h
//  iosNavigation
//
//  Created by Adam Elemental on 28/08/2015.
//
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    UINavigationBar* navBar;
    UIView* _contentView;
}
@property (nonatomic, retain) UIView* contentView;

- (id) initWithContentView: (UIView *) contentView;
- (void) addContentView;
- (void) nextView: (id) sender;

@end
