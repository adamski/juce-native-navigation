//
//  MainWindow.cpp
//  iosNavigation
//
//  Created by Adam Elemental on 30/08/2015.
//
//

#ifndef iosNavigation_iosMainWindow_mm
#define iosNavigation_iosMainWindow_mm

#import <UIKit/UIKit.h>
#include "iosMainWindow.h"
#include "MainComponent.h"
#import "TestViewController.h"
#import "MainViewController.h"

MainWindow::MainWindow (String name)  : DocumentWindow (name,
                                                        Colours::lightgrey,
                                                        DocumentWindow::allButtons)
{
        UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.backgroundColor = [UIColor grayColor];
        
        MainContentComponent* mainComponent = new MainContentComponent();
        UIView* juceView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        MainWindow::addComponentToUIView (*mainComponent, juceView);
        MainViewController* viewController = [[MainViewController alloc] initWithContentView: juceView];
        
        [viewController addContentView];
        
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: viewController];
        [window setRootViewController:navController];
        
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

void MainWindow::addComponentToUIView (Component& comp, void* uiView)
{
    comp.addToDesktop (0, uiView);
    UIView* view = (UIView*) uiView;
    comp.setVisible (true);
    comp.setBounds (view.bounds.origin.x, view.bounds.origin.y,
                    view.bounds.size.width, view.bounds.size.height);
}




#endif
