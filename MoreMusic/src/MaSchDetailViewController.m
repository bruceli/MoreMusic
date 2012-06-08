//
//  MaDetailViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaSchDetailViewController.h"
@interface MaSchDetailViewController (pravite)
-(void)initSubViews;
@end

@implementation MaSchDetailViewController
@synthesize info = _info;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];  
    scrollView = [ [UIScrollView alloc ] initWithFrame:bounds ];  
    scrollView.alwaysBounceVertical=YES;

    self.view = scrollView;
    scrollView.backgroundColor = [UIColor darkGrayColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    nameLabel = [[FXLabel alloc] initWithFrame:CGRectMake(10, 10,250 ,25)];
    
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 165 ,310 ,200)];
    
    [self initSubViews];
}

-(void)initSubViews
{
    NSMutableString* imgName = [NSMutableString stringWithString:[_info objectForKey:@"image"]];
    [imgName appendString:@"Detail.jpeg"];
    
    UIImage* image = [UIImage imageNamed:imgName];
    imageView = [[UIImageView alloc] initWithImage:image];
    
//    imageView.backgroundColor = [UIColor redColor];

    nameLabel.shadowColor = [UIColor darkGrayColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:25];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
    nameLabel.shadowBlur = 4.0f;
    nameLabel.text = [_info objectForKey:@"title"] ;
    if ([nameLabel.text length]>9) {
        nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:19];
    }

    NSMutableString* infoString = [[NSMutableString alloc] init];
    NSString* bandString = [_info objectForKey:@"band"];
    if ([bandString length]) {
        [infoString appendString:bandString];
        [infoString appendString:@"\n\n"];
    }
    [infoString appendString:[_info objectForKey:@"detail"]];
    detailLabel.text = infoString;
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
    detailLabel.textColor = [UIColor whiteColor];
    [detailLabel sizeToFit];
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,160, 320, detailLabel.frame.size.height+20)];
    
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImage.image = [UIImage imageNamed:@"detailBackground"];
    [self.view addSubview:backgroundImage];
    [self.view addSubview:detailLabel];
    [self.view addSubview:imageView];
    [self.view addSubview:nameLabel];

    CGSize viewSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height+detailLabel.frame.size.height+20);
    scrollView.contentSize = viewSize;


}

@end
