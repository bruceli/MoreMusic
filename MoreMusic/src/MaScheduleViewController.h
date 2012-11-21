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
    NSMutableArray* allActivityArray;  
    NSMutableArray* currentActivityArray;
    NSMutableDictionary* dataSource;
//    NSMutableArray* ;
//    NSMutableDictionary *secondDayActivityArray;        

    NSInteger currentActivity;
}
@property (nonatomic, copy, readonly) NSMutableArray* allActivityArray;



@end
