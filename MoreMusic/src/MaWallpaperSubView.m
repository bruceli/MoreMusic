//
//  MaWallpaperSubViewController.m
//  MoreMusic
//
//  Created by Accthun He on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaWallpaperSubView.h"

@interface MaWallpaperSubView ()

@end

@implementation MaWallpaperSubView
@synthesize rows;
@synthesize columns;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)layoutSubviews
{
    int widthSize = self.bounds.size.width / columns;
    int heightSize = self.bounds.size.height / rows;
    int index = 0;       
    for (int y = 0; y < rows; ++y) {
        for (int x = 0; x < columns; ++x) {
            UIView *subview = [self.subviews objectAtIndex:index++];
            subview.frame = CGRectMake(x * widthSize, y * heightSize, widthSize, heightSize);
        }
    }
}
@end
