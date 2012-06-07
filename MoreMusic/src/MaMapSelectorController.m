//
//  MaMapSelectorController.m
//  MoreMusic
//
//  Created by Accthun He on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaMapSelectorController.h"
#import "UIButton+Curled.h"
#import "MaMapViewController.h"
#import "FXLabel.h"

@interface MaMapSelectorController ()

@end

@implementation MaMapSelectorController

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
    UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"mapViewBackground.jpg"];
    [self.view addSubview:backgroundView];

    
    googleMapButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 30, 270, 130)];
    [googleMapButton setContentMode:UIViewContentModeScaleAspectFill];
    [googleMapButton setImage:[UIImage imageNamed:@"googleMap.png"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [googleMapButton addTarget:self action:@selector(loadGoogleMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:googleMapButton];
    
    FXLabel* googleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(130, 110, 150, 50)];
    googleLabel.shadowColor = [UIColor blackColor];
    googleLabel.backgroundColor = [UIColor clearColor];
    googleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:22];
    googleLabel.textColor = [UIColor whiteColor];
    googleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    googleLabel.shadowBlur = 4.0f;
    googleLabel.text = @"Google Map";
    [self.view addSubview:googleLabel];

    
    cartoonButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 200, 270, 130)];
    [cartoonButton setContentMode:UIViewContentModeScaleAspectFill];
    [cartoonButton setImage:[UIImage imageNamed:@"cartoonMap.png"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [cartoonButton addTarget:self action:@selector(loadCartoonMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cartoonButton];
    
    FXLabel* cartoonLabel = [[FXLabel alloc] initWithFrame:CGRectMake(130, 280, 150, 50)];
    cartoonLabel.shadowColor = [UIColor blackColor];
    cartoonLabel.backgroundColor = [UIColor clearColor];
    cartoonLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:22];
    cartoonLabel.textColor = [UIColor whiteColor];
    cartoonLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    cartoonLabel.shadowBlur = 4.0f;
    cartoonLabel.text = @"Cartoon Map";
    [self.view addSubview:cartoonLabel];

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


-(void)loadGoogleMap
{
    MaMapViewController* mapCtrller = [[MaMapViewController alloc]init];
    [self.navigationController pushViewController: mapCtrller animated:YES];
}

-(void)loadCartoonMap
{
    MaMapViewController* viewController = [[MaMapViewController alloc]init];
    [self.navigationController pushViewController: viewController animated:YES];
}

@end
