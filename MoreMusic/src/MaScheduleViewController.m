//
//  MaScheduleViewController.m
//  MoreMusic
//
//  Created by Accthun He on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MaMoreMusicDefine.h"
#import "MaScheduleViewController.h"
#import "MaTableViewController.h"
#import "NSDate-Utilities.h"

@interface MaScheduleViewController ()

@end

@implementation MaScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;          
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Schedule" image:[UIImage imageNamed:@"schedule"] tag:0];
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
    currentActivity = MaFirstDay;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ActivityDataSource" ofType:@"plist"];
    NSLog(@"Datasource Location... %@", path);
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    allActivityArray = [dict objectForKey:@"ActivityArray"];
    currentActivityArray = [[NSMutableArray alloc] init];
    dataSource = [[NSMutableDictionary alloc] init];

    //NSArray* array = [activityArray allKeys];
    
    //NSArray* array  = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ActivityDataSource" ofType:@"plist"]];

	// Do any additional setup after loading the view.
//    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.title = @"MaScheduleViewController";

    UITableViewController *listViewController1 = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	UITableViewController *listViewController2 = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
   
    // listViewController1.tableView.backgroundColor = [UIColor lightGrayColor];
    // listViewController2.tableView.backgroundColor = [UIColor grayColor];

	listViewController1.title = @"Day 1";
	listViewController2.title = @"Day 2";
    listViewController1.tableView.delegate = self; 
    listViewController1.tableView.dataSource = self; 
    listViewController2.tableView.delegate = self; 
    listViewController2.tableView.dataSource = self; 

	NSArray *viewControllers = [NSArray arrayWithObjects:listViewController1, listViewController2, nil];
	MHTabBarController *tabBarController = [[MHTabBarController alloc] init];
    
	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;
    
    [self.view addSubview:tabBarController.view ];
    [self addChildViewController:tabBarController];
    [tabBarController didMoveToParentViewController:self];

//    [self.view insertSubview:tabBarController.view  aboveSubview:self.tableView];

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




#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    NSArray* siteArray = [dataSource objectForKey:@"sectionNameArray"];
    int count = [siteArray count];
    NSLog(@"activity section count %d", count);
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    NSArray* siteArray = [dataSource objectForKey:@"sectionNameArray"];
    return [siteArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSInteger count = 0;
    // get section array from dataSource
    NSArray* siteArray = [dataSource objectForKey:@"sectionNameArray"];
    
    // get site name from array
    NSString* siteName = [siteArray objectAtIndex:section];
    
    // get activity array from site name
    NSArray* activityArray = [dataSource objectForKey:siteName];
    
    count = [activityArray count];
    return  count;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView { return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // get section array from dataSource
    NSArray* siteArray = [dataSource objectForKey:@"sectionNameArray"];
    
    // get site name from array
    NSString* siteName = [siteArray objectAtIndex:indexPath.section];
    
    // get activity array from site name
    NSArray* activityArray = [dataSource objectForKey:siteName];

    NSDictionary* dict = [activityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];

    
//    NSDictionary *book = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = [book objectForKey:@"title"];    
//    cell.detailTextLabel.text = [book objectForKey:@"description"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}



#pragma mark -
#pragma mark Table view data source 

-(void)updateSiteArray
{
    [dataSource removeAllObjects];
    NSMutableArray* sectionArray = [[NSMutableArray alloc] init];

    // get all site name
    for (NSDictionary *dict in currentActivityArray) {
        NSString* siteString = [dict objectForKey:@"site"];
        if(![sectionArray containsObject:siteString])
            [sectionArray addObject:siteString];
    }
    [dataSource setObject:sectionArray forKey:@"sectionNameArray"];

    // seprate array by site name
    for(NSString* siteString in sectionArray)
    {
        NSMutableArray* secArray  = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in currentActivityArray) {
            NSString* string = [dict objectForKey:@"site"];
            if([string isEqualToString:siteString])
                [secArray addObject:dict];     
            
        }
        [dataSource setObject:secArray forKey:siteString];
    }
}

-(void)updateCurrentActivityByDate:(NSUInteger)inDate
{
    [currentActivityArray removeAllObjects];
    
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    [mmddccyy setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"yyyy-MM-dd";
    NSDate *activityDate;
    
    if (inDate == MaFirstDay) {
         activityDate = [mmddccyy dateFromString:FIRST_DAY_STRING];
    }
    if (inDate == MaSecondDay) {
        activityDate = [mmddccyy dateFromString:SECOND_DAY_STRING];
    }
    
    for (NSDictionary *dict in allActivityArray) {
        NSDate* date = [dict objectForKey:@"date"];
        if([date isEqualToDateIgnoringTime:activityDate])
            [currentActivityArray addObject:dict];
    }
}


- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
    [self updateCurrentActivityByDate:index];
    [self updateSiteArray];
	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
    [self updateCurrentActivityByDate:index];
    [self updateSiteArray];
}


@end
