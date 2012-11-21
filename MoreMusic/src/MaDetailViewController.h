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
    
    UIButton* _headerImgView;
    UILabel* _textView;
    UIButton* _button1ImgView;
    UIButton* _button2ImgView;
    UIButton* _button3ImgView;
    UIButton* _button4ImgView;
    
    NSString* _text;
    
    UIView* popupView;
}

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *text;

-(void)initImageView;

@end
