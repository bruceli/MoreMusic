//
//  MaAboutViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaAboutViewController.h"
#import "FXLabel.h"


@interface MaAboutViewController ()

@end

@implementation MaAboutViewController

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
    
    self.navigationItem.title = NSLocalizedString(@"About",nil);

 /*   UIView* view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
*/    
    UIScrollView* _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds]; 
    _scrollView.alwaysBounceVertical=YES;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted-pattern"] ];
 
    self.view =_scrollView;

    UIView* view = [[UIView alloc]initWithFrame:self.view.bounds];
     view.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:view];

    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 305, 70)];
    detailLabel.text = NSLocalizedString(@"MaMoreInfo",nil);
    detailLabel.backgroundColor = [UIColor whiteColor];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
    detailLabel.textColor = [UIColor darkGrayColor];
    [detailLabel sizeToFit];
    [self.view addSubview:detailLabel];

    FXLabel* presentLabel = [[FXLabel alloc] initWithFrame:CGRectMake(20, detailLabel.frame.origin.y + detailLabel.frame.size.height , 320, 50)];
    presentLabel.shadowColor = [UIColor blackColor];
    presentLabel.backgroundColor = [UIColor whiteColor];
    presentLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
    presentLabel.textColor = [UIColor whiteColor];
    presentLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    presentLabel.shadowBlur = 4.0f;
    presentLabel.text = NSLocalizedString(@"MaPresentedBy",nil);
    [self.view addSubview:presentLabel];

    
    
    FXLabel* aboutLabel = [[FXLabel alloc] initWithFrame:CGRectMake(70, presentLabel.frame.origin.y + presentLabel.frame.size.height , 320, 50)];
    aboutLabel.shadowColor = [UIColor blackColor];
    aboutLabel.backgroundColor = [UIColor whiteColor];
    aboutLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:22];
    aboutLabel.textColor = [UIColor whiteColor];
    aboutLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    aboutLabel.shadowBlur = 4.0f;
    aboutLabel.text = NSLocalizedString(@"MagicApp",nil);
    [self.view addSubview:aboutLabel];
    
    FXLabel* emailLabel = [[FXLabel alloc] initWithFrame:CGRectMake(70, aboutLabel.frame.origin.y + aboutLabel.frame.size.height , 320, 50)];
    emailLabel.shadowColor = [UIColor blackColor];
    emailLabel.backgroundColor = [UIColor whiteColor];
    emailLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
    emailLabel.textColor = [UIColor whiteColor];
    emailLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    emailLabel.shadowBlur = 4.0f;
    emailLabel.text = NSLocalizedString(@"MaEmail",nil);
    [self.view addSubview:emailLabel];

    
    
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
