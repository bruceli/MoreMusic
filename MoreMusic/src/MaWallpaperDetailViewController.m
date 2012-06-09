//
//  MaWallpaperDetailViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaWallpaperDetailViewController.h"
#import "UIImageView+Curled.h"
#import "WBSuccessNoticeView.h"
#import "WBErrorNoticeView.h"

@interface MaWallpaperDetailViewController ()

@end

@implementation MaWallpaperDetailViewController
@synthesize wallPaperName = _wallPaperName;
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
    CGRect rect = self.view.bounds;
    [self.view setFrame:rect];

    CGRect frame = CGRectMake(20,5,280,345);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:250 alpha:1.0];
    
    [imageView setImage:[UIImage imageNamed:_wallPaperName] borderWidth:5.0 shadowDepth:19.0 controlPointXOffset:30.0 controlPointYOffset:70.0];

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
	self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.title = NSLocalizedString(@"Wallpaper",nil);

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

-(void)save
{
    UIImage* img = [UIImage imageNamed:_wallPaperName];
    NSParameterAssert(img);
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  

    if (!error) {  
        WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:@"Wallpaper Saved Successfully."];
        [notice show];
    } else {  
        WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Error" message:@"Can't save wallpaper."];
        [notice show];
    }  
}  


@end
