//
//  MaDetailViewController.h
//  MoreMusic
//
//  Created by Accthun He on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaDetailViewController : UIViewController
{
    // baseView
    UIScrollView* _scrollView;

    UIImageView* _imageView;
    NSString* _imageName;
}

@property (nonatomic, copy) NSString *imageName;
-(void)initImageView;

@end
