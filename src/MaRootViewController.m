//
//  MaRootViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaRootViewController.h"
@interface MaRootViewController ()

@end

@implementation MaRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    tabBarController = [[UITabBarController alloc] init]; 
    
    app.scheduleViewController = [[MaScheduleViewController alloc] init]; 
	UINavigationController* schViewController = [[UINavigationController alloc] initWithRootViewController:app.scheduleViewController];

    app.bandViewController = [[MaBandViewController alloc] init]; 
	UINavigationController* banViewController = [[UINavigationController alloc] initWithRootViewController:app.bandViewController];
    
    app.reviewViewController = [[MaReviewViewController alloc] init]; 
	UINavigationController* revViewController = [[UINavigationController alloc] initWithRootViewController:app.reviewViewController];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:schViewController, banViewController, revViewController, nil];

    [self.view addSubview:tabBarController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
