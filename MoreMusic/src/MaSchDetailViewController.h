//
//  MaDetailViewController.h
//  MoreMusic
//
//  Created by Accthun He on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@interface MaSchDetailViewController : UIViewController
{
    // baseView
    UIScrollView* scrollView;
    UIImageView* imageView;
    NSDictionary* _info;
    UIImageView* backgroundImage;
    
    FXLabel* nameLabel;
    FXLabel* bandLabel;
    UILabel* detailLabel;
}

@property (nonatomic, copy) NSDictionary *info;
//-(void)initImageView;

@end
