//
//  MaDetailViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaDetailViewController.h"
#import "UIButton+Curled.h"
#import "MaDetailImageViewController.h"

@implementation MaDetailViewController
@synthesize imageName = _imageName;
@synthesize text = _text;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];  
    _scrollView = [ [UIScrollView alloc ] initWithFrame:bounds ];  
    self.view = _scrollView;
    _scrollView.backgroundColor = [UIColor darkGrayColor];
    
    
}

-(void)initImageView
{
/*    UIImage* image = [UIImage imageNamed:_imageName];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_imageView];
    _scrollView.contentSize = image.size;
*/
    
    // HeaderImage
    NSMutableString* headerName = [NSMutableString stringWithString:_imageName];
    [headerName appendString:@"header.jpeg"];
    
    UIImage* headerImage = [UIImage imageNamed:headerName];
    if (headerImage.size.width> headerImage.size.height)
        _headerImgView = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    else 
        _headerImgView = [[UIButton alloc] initWithFrame:CGRectMake(35, 10, 250, 330)];
    
    [_headerImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_headerImgView setImage:[UIImage imageNamed:headerName] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [_headerImgView addTarget:self action:@selector(loadHeaderImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerImgView];


    float baseLineY = _headerImgView.frame.origin.y + _headerImgView.frame.size.height + 10;
    
    NSMutableString* imageNameB1 = [NSMutableString stringWithString:_imageName];
    [imageNameB1 appendString:@"B1.jpeg"];
    _button1ImgView = [[UIButton alloc] initWithFrame:CGRectMake(10, baseLineY, 145, 100)];
    [_button1ImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_button1ImgView setImage:[UIImage imageNamed:imageNameB1] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [_button1ImgView addTarget:self action:@selector(loadImageA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1ImgView];

    NSMutableString* imageNameB2 = [NSMutableString stringWithString:_imageName];
    [imageNameB2 appendString:@"B2.jpeg"];
    _button2ImgView = [[UIButton alloc] initWithFrame:CGRectMake(165, baseLineY, 145, 100)];
    [_button2ImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_button2ImgView setImage:[UIImage imageNamed:imageNameB2] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [_button2ImgView addTarget:self action:@selector(loadImageB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2ImgView];

    NSMutableString* imageNameB3 = [NSMutableString stringWithString:_imageName];
    [imageNameB3 appendString:@"B3.jpeg"];
    _button3ImgView = [[UIButton alloc] initWithFrame:CGRectMake(10, baseLineY+110, 145, 100)];
    [_button3ImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_button3ImgView setImage:[UIImage imageNamed:imageNameB3] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [_button3ImgView addTarget:self action:@selector(loadImageC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button3ImgView];
    
    NSMutableString* imageNameB4 = [NSMutableString stringWithString:_imageName];
    [imageNameB4 appendString:@"B4.jpeg"];
    _button4ImgView = [[UIButton alloc] initWithFrame:CGRectMake(165, baseLineY+110, 145, 100)];
    [_button4ImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_button4ImgView setImage:[UIImage imageNamed:imageNameB4] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0 forState:UIControlStateNormal];
    [_button4ImgView addTarget:self action:@selector(loadImageD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button4ImgView];

    
    // TEXT 
    
    _textView = [[UILabel alloc] initWithFrame:CGRectMake(10,_button4ImgView.frame.origin.y + _button4ImgView.frame.size.height + 20,  300, 100)];
    _textView.text = _text;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.numberOfLines = 0;
    _textView.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    _textView.textColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    [_textView sizeToFit];

    CGSize size = _scrollView.frame.size;
    size.height= _textView.frame.size.height+_textView.frame.origin.y;
    _scrollView.contentSize = size;
}

-(void)loadHeaderImage:(id)sender
{
    NSMutableString* headerName = [NSMutableString stringWithString:_imageName];
    [headerName appendString:@"header.jpeg"];

    MaDetailImageViewController* viewController = [[MaDetailImageViewController alloc]init];
    viewController.imageName = headerName;
    [self.navigationController pushViewController: viewController animated:YES];

    
    
}

-(void)loadImageA
{
    NSMutableString* imageNameB1 = [NSMutableString stringWithString:_imageName];
    [imageNameB1 appendString:@"B1.jpeg"];
    MaDetailImageViewController* viewController = [[MaDetailImageViewController alloc]init];
    viewController.imageName = imageNameB1;
    [self.navigationController pushViewController: viewController animated:YES];
}

-(void)loadImageB
{
    
    NSMutableString* imageNameB2 = [NSMutableString stringWithString:_imageName];
    [imageNameB2 appendString:@"B2.jpeg"];
    MaDetailImageViewController* viewController = [[MaDetailImageViewController alloc]init];
    viewController.imageName = imageNameB2;
    [self.navigationController pushViewController: viewController animated:YES];

}

-(void)loadImageC
{
    NSMutableString* imageNameB3 = [NSMutableString stringWithString:_imageName];
    [imageNameB3 appendString:@"B3.jpeg"];
    MaDetailImageViewController* viewController = [[MaDetailImageViewController alloc]init];
    viewController.imageName = imageNameB3;
    [self.navigationController pushViewController: viewController animated:YES];

    
}

-(void)loadImageD
{
    
    NSMutableString* imageNameB4 = [NSMutableString stringWithString:_imageName];
    [imageNameB4 appendString:@"B4.jpeg"];
    MaDetailImageViewController* viewController = [[MaDetailImageViewController alloc]init];
    viewController.imageName = imageNameB4;
    [self.navigationController pushViewController: viewController animated:YES];

}


@end
