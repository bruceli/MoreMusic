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
#import "POAPinyin.h"

@interface NSDictionary(nameCompare)
- (NSComparisonResult)compareName: (NSDictionary*)anotherDict;
@end

@implementation NSDictionary(nameCompare)
- (NSComparisonResult)compareName: (NSDictionary*)anotherDict
{
    NSDictionary *firstDict = self;
    NSString *first = [firstDict objectForKey: @"title"];
    NSString *second = [anotherDict objectForKey: @"title"];

    NSString* firstPY = [POAPinyin Convert:first];
    NSString* secondPY = [POAPinyin Convert:second];
    
//    NSLog(@"%@ = %@",first,firstPY );
//    NSLog(@"%@ = %@",second,secondPY );

    return [firstPY compare: secondPY];    
}
@end

@interface MaBandViewController ()

@end

@implementation MaBandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
        dataSource = [NSMutableArray arrayWithArray: app.scheduleViewController.allActivityArray];
        [dataSource sortUsingSelector:@selector(compareName:)];
        
        // unable sort "唵", move it to the top of array.
        NSDictionary* temp = [dataSource objectAtIndex:[dataSource count]-1 ];
        [dataSource insertObject:temp atIndex:0];
        [dataSource removeObjectAtIndex:[dataSource count]-1];
        
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
    cell.isSchCell = NO;
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
