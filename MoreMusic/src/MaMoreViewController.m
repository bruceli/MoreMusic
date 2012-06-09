//
//  MaMoreViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaMoreViewController.h"
#import "FXLabel.h"
#import "MaSchViewCell.h"
#import "MaMapSelectorController.h"
#import "MaTicketViewController.h"
#import "MaWallpaperViewController.h"

@implementation MaMoreViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
        dataSource = [NSMutableArray arrayWithObjects:@"Map", @"Ticket",@"Wallpaper", @"About", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"More",nil);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MaSchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MaSchViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.isSchCell = NO;
    cell.nameString =  NSLocalizedString([dataSource objectAtIndex:indexPath.row],nil);
    cell.bandImgName = [[dataSource objectAtIndex:indexPath.row] lowercaseString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            MaMapSelectorController* viewController = [[MaMapSelectorController alloc]init];
            [self.navigationController pushViewController: viewController animated:YES];
            break;
        }
            
        case 1:{
            MaTicketViewController* viewController = [[MaTicketViewController alloc]init];
            [self.navigationController pushViewController: viewController animated:YES];
            break;
        }
            
        case 2:{
            MaWallpaperViewController* viewController = [[MaWallpaperViewController alloc]init];
            [self.navigationController pushViewController: viewController animated:YES];
            break;
        }

        case 3:{
            UIViewController* detViewController = [[UIViewController alloc]init];
            [self.navigationController pushViewController: detViewController animated:YES];
            break;
        }
            

        default:
            break;
    }    
}



@end
