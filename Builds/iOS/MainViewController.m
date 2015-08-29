//
//  MainViewController.m
//  iosNavigation
//
//  Created by Adam Elemental on 28/08/2015.
//
//

#import "MainViewController.h"
#import "TestViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id) initWithContentView: (UIView *) contentView {
    self = [super init];
    
    if (self) {
        _contentView = contentView;
    }
    
    return self;
}

- (void) addContentView {
    [self.view addSubview:_contentView];
}

- (void) nextView: (id) sender
{
    TestViewController * testViewcontroller = [[[TestViewController alloc] init] autorelease];
    [self.navigationController pushViewController:testViewcontroller animated:YES];
}

- (void) loadView {
    [super loadView];

    
    CGRect frame = self.view.bounds;
    CGFloat navHeight = 32.0;
    
    
    navBar = [[UINavigationBar alloc] initWithFrame:frame];
    frame.size = [navBar sizeThatFits:frame.size];
    [navBar setFrame:frame];
    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [navBar setBarTintColor:[UIColor blackColor]];
    [navBar setTintColor:[UIColor grayColor]];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName, nil]; //,
    //                                                               //[UIColor grayColor], UITextAttributeTextShadowColor,
    //                                                               //[NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    //
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                             target:self
                                                                             action:@selector(nextView:)];
    [[self navigationItem] setRightBarButtonItem:button];
    [button release];
    [navBar setItems:[NSArray arrayWithObject:self.navigationItem]];
    
    [self.view addSubview:navBar];
    
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           navHeight,
                                                           self.view.bounds.size.width,
                                                           self.view.bounds.size.height-navHeight)];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    //[self.view addSubview:_contentView];
    
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [_contentView release];
    [navBar release];
    
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
