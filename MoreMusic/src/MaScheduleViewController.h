//
//  MaScheduleViewController.h
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "MaTableViewController.h"
#import "MaRootViewController.h"
#import "MHTabBarController.h"

//UITableViewController
@interface MaScheduleViewController : MaRootViewController <UITableViewDelegate, UITableViewDataSource, MHTabBarControllerDelegate>
{
    NSMutableArray* activityArray;  
    NSMutableArray* sectionArray;
//    NSMutableDictionary *secondDayActivityArray;        

    NSInteger currentActivity;
}

@end
