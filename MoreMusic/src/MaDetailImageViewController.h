//
//  MaDetailImageViewController.h
//  MoreMusic
//
//  Created by Accthun He on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaDetailImageViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    NSString* _imageName;
}

@property (nonatomic, copy) NSString* imageName;

@end
