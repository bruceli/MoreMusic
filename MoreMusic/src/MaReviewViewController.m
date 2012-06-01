//
//  MaReviewViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaReviewViewController.h"
#import "MaDetailViewController.h"

@interface MaReviewViewController ()

@end

@implementation MaReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Review" image:[UIImage imageNamed:@"review"] tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.title = @"MaReviewViewController";
    NSString* path = [[NSBundle mainBundle] pathForResource:@"history" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    histroyArray = [dict objectForKey:@"historyArray"];
 
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
    return [histroyArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // get section array from dataSource
    NSDictionary* dict = [histroyArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [histroyArray objectAtIndex:indexPath.row];

    MaDetailViewController* detViewController = [[MaDetailViewController alloc]init];
    detViewController.imageName = [dict objectForKey:@"detailImage"];
    
    [detViewController initImageView];
    
    [self.navigationController pushViewController: detViewController animated:YES];
}




@end
