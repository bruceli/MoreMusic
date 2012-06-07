//
//  MaWallpaperViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaWallpaperViewController.h"
#import "MaWallpaperSubView.h"
#import "MaWallpaperSubViewController.h"

@interface MaWallpaperViewController ()

@end

@implementation MaWallpaperViewController

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
    int columns = 4;
    int rows = 4;
    
    //! just some random child controllers generation
    MaWallpaperSubView *containerView = [[MaWallpaperSubView alloc] init];
    self.view = containerView;
    containerView.rows = rows;
    containerView.columns = columns;
    NSInteger fileSeq = 0;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:columns * rows];
    for (int i = 0; i < columns * rows; ++i) {
        MaWallpaperSubViewController *subController = [[MaWallpaperSubViewController alloc] init];
        subController.view.backgroundColor = [UIColor colorWithWhite:50 alpha:0.5];
        
        NSMutableString* fileName = [NSMutableString stringWithString: @"moreHappyWallPaper"];
        [fileName appendString:[NSString stringWithFormat: @"%d", fileSeq]];
        [fileName appendString:@".jpg"];

        NSLog(@"File named %@",fileName);
        subController.wallPaperName = fileName;
        [containerView addSubview:subController.view];
        [viewControllers addObject:subController];
        fileSeq++;
    }  
    
    [self setViewControllers:viewControllers];
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
