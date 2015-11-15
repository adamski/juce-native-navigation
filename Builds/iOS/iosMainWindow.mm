//
//  MainWindow.cpp
//  JustTuner
//
//  Created by Adam Elemental on 30/08/2015.
//
//

#ifndef JustTuner_iosMainWindow_mm
#define JustTuner_iosMainWindow_mm

#ifdef JUCE_IOS
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NativeNavigation-Swift.h"
#include "iosMainWindow.h"
#include "MainComponent.h"


//-----------------------------------------------------------

MainWindow::MainWindow (String name)  : DocumentWindow (name,
                                                        Colours::lightgrey,
                                                        DocumentWindow::allButtons)
{
    
//    NSError *setCategoryError = nil;
//    BOOL success = [[AVAudioSession sharedInstance]
//                    setCategory: AVAudioSessionCategoryPlayAndRecord
//                    error: &setCategoryError];
//    
//    if (!success)
//    {
//        /* handle the error in setCategoryError */
//        DBG ("Error setting category AVAudioSessionCategoryPlayAndRecord");
//    }

    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor grayColor];
    
    UIView* juceView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    MainWindow::addComponentToUIView (mainComponent, juceView);
    JuceViewController* juceViewController = [[JuceViewController alloc] initWithContentView: juceView];
    
    juceViewController.contentView = juceView;
    UINavigationController* detailNavController;
    
    MasterViewController* masterViewController = [[MasterViewController alloc] init];
    UINavigationController* masterNavController = [[UINavigationController alloc] initWithRootViewController: masterViewController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        detailNavController = [[UINavigationController alloc] initWithRootViewController: juceViewController];
        UISplitViewController* splitVC = [[UISplitViewController alloc] init];
        splitVC.viewControllers = [NSArray arrayWithObjects:masterNavController, detailNavController, nil];
        [window setRootViewController:splitVC];
    }
    else
    {
        masterViewController.juceViewController = juceViewController;
        detailNavController = [[UINavigationController alloc] initWithRootViewController: masterViewController];
        [detailNavController pushViewController:juceViewController animated:false];
        [window setRootViewController:detailNavController];
    }
    //[window addSubview:splitVC.view];
    
    // Style navigation bar
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName, nil]; //,
    //                                                               //[UIColor grayColor], UITextAttributeTextShadowColor,
    //                                                               //[NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    //
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    UINavigationBar.appearance.barTintColor = [UIColor blackColor];
    UINavigationBar.appearance.tintColor = [UIColor whiteColor];
    
    [window makeKeyAndVisible];
}
    
void MainWindow::closeButtonPressed()
{
    // This is called when the user tries to close this window. Here, we'll just
    // ask the app to quit when this happens, but you can change this to do
    // whatever you need.
    JUCEApplication::getInstance()->systemRequestedQuit();
}

void MainWindow::addComponentToUIView (Component& component, void* uiView)
{
    component.addToDesktop (0, uiView);
    UIView* view = (UIView*) uiView;
    component.setVisible (true);
    component.setBounds (view.bounds.origin.x, view.bounds.origin.y,
                    view.bounds.size.width, view.bounds.size.height);
}


#endif

#endif
