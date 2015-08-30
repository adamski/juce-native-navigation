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

    CGFloat navHeight = 32.0;

    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                        target:self
                                                        action:@selector(nextView:)];
    [[self navigationItem] setRightBarButtonItem:button];
    [button release];
    
    [[self navigationItem] setTitle: @"Hello"];
    
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
