//
//  MaSchViewCell.h
//  MoreMusic
//
//  Created by Accthun He on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@interface MaSchViewCell : UITableViewCell
{
    NSString* _nameString;
    NSDate* _startTime;
    NSDate* _endTime;
    NSString* _bandImgName;
    
    FXLabel* nameLabel;
    UILabel* timeLabel;
    UILabel* endTimeLabel;
    UIImageView* bandImgView;
    
    BOOL _isSchCell;
    
}

@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSDate *endTime;
@property (nonatomic, copy) NSString *bandImgName;
@property (nonatomic) BOOL isSchCell;

@end
