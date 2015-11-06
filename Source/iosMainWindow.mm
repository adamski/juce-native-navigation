//
//  MainWindow.cpp
//  JustTuner
//
//  Created by Adam Elemental on 30/08/2015.
//
//

#ifndef JustTuner_iosMainWindow_mm
#define JustTuner_iosMainWindow_mm

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "JustTuner-Swift.h"
#include "iosMainWindow.h"
#include "MainComponent.h"
#import "DatabaseController.h"


#define kDatabaseName @"justtuner-scales"

//-----------------------------------------------------------

MainWindow::MainWindow (String name)  : DocumentWindow (name,
                                                        Colours::lightgrey,
                                                        DocumentWindow::allButtons)
{
    
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayAndRecord
                    error: &setCategoryError];
    
    if (!success)
    {
        /* handle the error in setCategoryError */
        DBG ("Error setting category AVAudioSessionCategoryPlayAndRecord");
    }
    
    DatabaseController *dbController = [[DatabaseController alloc] init];
    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor grayColor];
    

    
    MainContentComponent* mainComponent = new MainContentComponent();
    UIView* juceView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    MainWindow::addComponentToUIView (*mainComponent, juceView);
    ScaleViewController* scaleViewController = [[ScaleViewController alloc] initWithContentView: juceView];
    
    scaleViewController.contentView = juceView;
    UINavigationController* detailNavController;
    
    
    MasterViewController* masterViewController = [[MasterViewController alloc] init];
    UINavigationController* masterNavController = [[UINavigationController alloc] initWithRootViewController: masterViewController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        detailNavController = [[UINavigationController alloc] initWithRootViewController: scaleViewController];
        UISplitViewController* splitVC = [[UISplitViewController alloc] init];
        splitVC.viewControllers = [NSArray arrayWithObjects:masterNavController, detailNavController, nil];
        [window setRootViewController:splitVC];
    }
    else
    {
        masterViewController.scaleViewController = scaleViewController;
        detailNavController = [[UINavigationController alloc] initWithRootViewController: masterViewController];
        [detailNavController pushViewController:scaleViewController animated:false];
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

    // Couchbase Lite setup

    #pragma mark Initialize Couchbase Lite and find/create my database:
    NSError* error;
    dbController.database = [[CBLManager sharedInstance] databaseNamed: kDatabaseName error: &error];
    if (!dbController.database) {
        [dbController showAlert: @"Couldn't open database" error: error fatal: YES];

        //return NO; // <-- quit after alert?
    }
    
    // Tell the controllers about the database:
    [scaleViewController useDatabase: dbController.database];
    [masterViewController useDatabase: dbController.database];

    [CBLManager enableLogging: @"Database"];
    [CBLManager enableLogging: @"Query"];

    #ifdef kServerDbURL
    #pragma mark Initialize bidirectional continuous sync:
    NSURL* serverDbURL = [NSURL URLWithString: kServerDbURL];
    _pull = [dbController.database createPullReplication: serverDbURL];
    _push = [dbController.database createPushReplication: serverDbURL];
    _pull.continuous = _push.continuous = YES;
    // Observe replication progress changes, in both directions:
    NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: _pull];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: _push];
    [_push start];
    [_pull start];
    #endif
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
