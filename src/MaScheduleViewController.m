//
//  MaScheduleViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaScheduleViewController.h"

@interface MaScheduleViewController ()

@end

@implementation MaScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;          
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Schedule" image:[UIImage imageNamed:@"clock"] tag:0];
        return self;


    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.title = @"MaScheduleViewController";
    [[UINavigationBar appearance] setTintColor:[UIColor brownColor]];    
    [[UINavigationBar appearanceWhenContainedIn:[MaScheduleViewController class], nil] setTintColor:[UIColor blackColor]];    
    
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


/*
- (id<UITableViewDelegate>)createDelegate {
    return [[TTTableViewDragRefreshDelegate alloc] initWithController:self];
}
*/
-(void)createModel
{ 
}


@end
