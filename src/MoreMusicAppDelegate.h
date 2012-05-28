//
//  MoreMusicAppDelegate.h
//  MoreMusic
//
//  Created by Accthun He on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaScheduleViewController.h"
#import "MaBandViewController.h"
#import "MaReviewViewController.h"
#import "MaWeiboStreamViewController.h"
#import "MaMoreViewController.h"

@interface MoreMusicAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    MaScheduleViewController* _scheduleViewController;
    MaBandViewController*   _bandViewController;
    MaReviewViewController* _reviewViewController;
    MaWeiboStreamViewController* _weiboStreamViewController;
    MaMoreViewController* _moreViewController;
    UITabBarController *tabBarController;

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MaScheduleViewController* scheduleViewController;
@property (nonatomic, retain) MaBandViewController*   bandViewController;
@property (nonatomic, retain) MaReviewViewController* reviewViewController;
@property (nonatomic, retain) MaWeiboStreamViewController* weiboStreamViewController;
@property (nonatomic, retain) MaMoreViewController* moreViewController;


@end
