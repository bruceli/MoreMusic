//
//  MaTicketViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaTicketViewController.h"
#import "UIButton+Curled.h"
#import "MaStudentTicketViewController.h"

@interface MaTicketViewController ()

@end

@implementation MaTicketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TTNavigator *navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    navigator.delegate = self;
    self.navigationItem.title = NSLocalizedString(@"Ticket",nil);

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view = scrollView;
    scrollView.backgroundColor = [UIColor darkGrayColor];
 /*   
    UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];  
    [self.view addSubview: backgroundView];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.image = [UIImage imageNamed:@"detailBackground.jpeg"];
 */   
    NSError* error;
    CGRect frame = CGRectMake(5, 5, 310, self.view.bounds.size.height);
    TTStyledTextLabel* ticketView = [[TTStyledTextLabel alloc] initWithFrame:frame];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ticket" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    ticketView.text = [TTStyledText textFromXHTML:text lineBreaks:YES URLs:YES];
    ticketView.textColor = [UIColor whiteColor];
    ticketView.backgroundColor = [UIColor clearColor];
    ticketView.font = [UIFont fontWithName:@"MicrosoftYaHei" size:12];
    [ticketView sizeToFit];
    [self.view addSubview:ticketView];
    
    
    scrollView.contentSize = ticketView.frame.size;

 /*   frame = CGRectMake(10, ticketView.frame.size.height+15, 300, 55);
    UIButton* ticketButton = [[UIButton alloc] initWithFrame:frame];
    
    [ticketButton addTarget:self action:@selector(loadStudentTicketView) forControlEvents:UIControlEventTouchUpInside];
    [ticketButton setImage:nil borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [self.view addSubview:ticketButton];
 */   
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


- (BOOL) navigator:(TTBaseNavigator *)navigator shouldOpenURL:(NSURL *)URL {
    // Now you can catch the clicked URL, and can do whatever with it
    // For Example: In my case, I take the query of the URL
    // If no query is available, let the app open the URL in Safari
    // If there's query, get its value and process within the app
    BOOL result = YES;
    
    NSString *query = [URL relativeString];
    if ([query length]>0)
    {
        result = NO;
        [[ UIApplication sharedApplication ] openURL: URL ];
    }
    return result;
}

-(void)loadStudentTicketView
{
    MaStudentTicketViewController* viewController = [[MaStudentTicketViewController alloc]init];
    [self.navigationController pushViewController: viewController animated:YES];
}
@end
