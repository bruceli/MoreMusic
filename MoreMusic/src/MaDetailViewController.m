//
//  MaDetailViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaDetailViewController.h"

@implementation MaDetailViewController
@synthesize imageName = _imageName;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];  
    _scrollView = [ [UIScrollView alloc ] initWithFrame:bounds ];  
    self.view = _scrollView;

}

-(void)initImageView
{
    UIImage* image = [UIImage imageNamed:_imageName];
    _imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_imageView];
    _scrollView.contentSize = image.size;
}


@end
