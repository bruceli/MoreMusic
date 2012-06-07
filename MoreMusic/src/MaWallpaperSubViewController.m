//
//  MaWallpaperDetailViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MaWallpaperSubViewController.h"
#import "MaWallpaperDetailViewController.h"
@interface MaWallpaperSubViewController ()

@end

@implementation MaWallpaperSubViewController
@synthesize wallPaperName = _wallPaperName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    [self.view addGestureRecognizer:  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect frame = CGRectMake(0,0,79,90);

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    UIImage* image = [UIImage imageNamed:_wallPaperName];
    imageView.image = image;
    [imageView setContentMode:UIViewContentModeScaleToFill];

    [self.view addSubview:imageView];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dismissModal
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"child view controller %@ appeared, self.parentController is %@ %@", self, self.parentViewController, self.modalViewController);
    
    //! make sure nested controllers unwind
    if (!self.parentViewController || [self.parentViewController isKindOfClass:[self class]]) {
        [self performSelector:@selector(dismissModal) withObject:nil afterDelay:1];
    }
}


- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImage* image = [UIImage imageNamed:_wallPaperName];
    if (image) {
        MaWallpaperDetailViewController *viewController = [[MaWallpaperDetailViewController alloc] init];
        viewController.wallPaperName = _wallPaperName;
        [self.navigationController pushViewController: viewController animated:YES];
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
