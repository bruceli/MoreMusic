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
    activityArray = [dict objectForKey:@"ActivityArray"];
    
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
 /*   listViewController1.tableView.delegate = self; 
    listViewController1.tableView.dataSource = self; 
    listViewController2.tableView.delegate = self; 
    listViewController2.tableView.dataSource = self; 
*/
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
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 0;
    //NSInteger count =  [[activityArray allKeys] count];
    NSLog(@"activity section count %d", count);
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
//    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
//    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];}
*/
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    switch (currentActivity) {
        case MaFirstDay:

            break;
            
        case MaSecondDay:

            break;  
            
        default:
            break;  
    }

    
//    NSDictionary *book = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = [book objectForKey:@"title"];    
//    cell.detailTextLabel.text = [book objectForKey:@"description"];
	
    return cell;
}




- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
    
    switch (index) {
        case MaFirstDay:
            currentActivity = MaFirstDay;
            break;
            
        case MaSecondDay:
            currentActivity = MaSecondDay;
            break;  
            
        default:
            currentActivity = MaFirstDay;
    }
    
    
	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);
    
	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
    
    switch (index) {
        case MaFirstDay:
            currentActivity = MaFirstDay;
            break;
            
        case MaSecondDay:
            currentActivity = MaSecondDay;
            break;  
            
        default:
            currentActivity = MaFirstDay;
    }

}

#pragma mark -
#pragma mark Table view data source 
/*
-(NSArray*)getItemsBySiteName:(NSString*)site
{
    NSMutableArray* array = [[NSMutableArray alloc] init]; 
    
    for (NSDictionary *dict in array) {
        if (![dict objectForKey:@"site"]) {
            [dict setObject:[NSMutableArray array] forKey:location.country];
        }
        [(NSMutableArray *)[dict objectForKey:location.country] addObject:location];

    }
}

-(NSArray*)getItemsByDate:(NSDate*)date
{


}
 */
@end
