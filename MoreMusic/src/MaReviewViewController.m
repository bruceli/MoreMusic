//
//  MaReviewViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaReviewViewController.h"
#import "MaDetailViewController.h"
#import "FXLabel.h"

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
    //cell.textLabel.text = [dict objectForKey:@"title"];
    
    FXLabel *nameLabel = [[FXLabel alloc] initWithFrame:CGRectMake(5, 5,310 , 50)];
    nameLabel.text = [dict objectForKey:@"title"];
    [cell addSubview:nameLabel];
    nameLabel.shadowColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    if ([nameLabel.text length]> 14) 
        nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20];
    else
        nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:27];

    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    nameLabel.shadowBlur = 8.0f;

    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[dict objectForKey:@"backgroundImage"]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [histroyArray objectAtIndex:indexPath.row];

    MaDetailViewController* detViewController = [[MaDetailViewController alloc]init];
    detViewController.imageName = [dict objectForKey:@"detailImage"];
    detViewController.text = [dict objectForKey:@"text"];

    [detViewController initImageView];
    
    [self.navigationController pushViewController: detViewController animated:YES];
}




@end
