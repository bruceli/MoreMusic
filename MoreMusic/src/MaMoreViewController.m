//
//  MaMoreViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaMoreViewController.h"

@implementation MaMoreViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
        
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           @"Generic Items",
                           [TTTableSettingsItem itemWithText:Three20Version caption:@"Three20 Version"
                                                         URL:@"tt://tableItemTest"],
                           [TTTableTextItem itemWithText:@"TTTableTextItem" URL:@"tt://tableItemTest"
                                            accessoryURL:@"http://www.google.com"],
                           nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"MaMoreViewController";
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
