//
//  MaAppDelegate.m
//  MoreMusic
//
//  Created by Accthun He on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreMusicAppDelegate.h"
#import "MaRootViewController.h"
#import "MaAuthMgr.h"
@implementation MoreMusicAppDelegate

@synthesize window = _window;
@synthesize scheduleViewController = _scheduleViewController;
@synthesize bandViewController = _bandViewController;
@synthesize reviewViewController = _reviewViewController;
@synthesize weiboStreamViewController = _weiboStreamViewController;
@synthesize moreViewController = _moreViewController;
@synthesize authMgr = _authMgr;
@synthesize tabBarController = _tabBarController;

//@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    TTNavigator* navigator = [TTNavigator navigator];
//    navigator.persistenceMode = TTNavigatorPersistenceModeAll;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    TTURLMap* map = navigator.URLMap;
//    [map from:@"*" toViewController:[TTWebController class]];
//    [map                    from: @"tt://ticket" toSharedViewController: [MaTicketViewController class]];

    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    _tabBarController = [[UITabBarController alloc] init]; 
    UITabBar *tabBar = [_tabBarController tabBar]; 
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarBackground"]];
    
    self.window.rootViewController = _tabBarController;
    
    app.scheduleViewController = [[MaScheduleViewController alloc] init]; 
	UINavigationController* schViewController = [[UINavigationController alloc] initWithRootViewController:app.scheduleViewController];
    UINavigationBar* navBar = schViewController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBackground"] forBarMetrics:UIBarMetricsDefault];

    app.bandViewController = [[MaBandViewController alloc] init]; 
	UINavigationController* banViewController = [[UINavigationController alloc] initWithRootViewController:app.bandViewController];
    navBar = banViewController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBackground"] forBarMetrics:UIBarMetricsDefault];
    

    app.reviewViewController = [[MaReviewViewController alloc] init]; 
	UINavigationController* revViewController = [[UINavigationController alloc] initWithRootViewController:app.reviewViewController];
    navBar = revViewController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBackground"] forBarMetrics:UIBarMetricsDefault];

    
    app.weiboStreamViewController = [[MaWeiboStreamViewController alloc] init]; 
	UINavigationController* weiViewController = [[UINavigationController alloc] initWithRootViewController:app.weiboStreamViewController];
    navBar = weiViewController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBackground"] forBarMetrics:UIBarMetricsDefault];

    
    app.moreViewController = [[MaMoreViewController alloc] init]; 
	UINavigationController* morViewController = [[UINavigationController alloc] initWithRootViewController:app.moreViewController];
    navBar = morViewController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBackground"] forBarMetrics:UIBarMetricsDefault];

    _tabBarController.viewControllers = [NSArray arrayWithObjects:schViewController, banViewController, revViewController, weiViewController, morViewController, nil];
    
    [self.window addSubview:_tabBarController.view];
    [self.window makeKeyAndVisible];
    
    
    _authMgr = [[MaAuthMgr alloc] init];

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
