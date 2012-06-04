//
//  MaBandViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MoreMusicAppDelegate.h"
#import "MaBandViewController.h"
#import "MaSchViewCell.h"
#import "MaSchDetailViewController.h"
@interface MaBandViewController ()

@end

@implementation MaBandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
        dataSource = [NSArray arrayWithArray: app.scheduleViewController.allActivityArray];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Band" image:[UIImage imageNamed:@"band"] tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"MaBandViewController";
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSInteger count = 0;
    // get section array from dataSource
    count = [dataSource count];
    return  count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MaSchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MaSchViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dict = [dataSource objectAtIndex:indexPath.row];
    cell.nameString = [dict objectForKey:@"title"];
    cell.startTime = [dict objectForKey:@"date"];
    cell.endTime = [dict objectForKey:@"endDate"];
    cell.isBandCell = NO;
    cell.bandImgName = [dict objectForKey:@"image"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get section array from dataSource
    NSDictionary* dict = [dataSource objectAtIndex:indexPath.row];
    
    MaSchDetailViewController* detViewController = [[MaSchDetailViewController alloc]init];
    detViewController.info = dict;
    
    [self.navigationController pushViewController: detViewController animated:YES];
}



@end
