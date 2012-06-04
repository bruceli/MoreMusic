//
//  MaSchViewCell.m
//  MoreMusic
//
//  Created by Accthun He on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaSchViewCell.h"
#import "NSDate-Utilities.h"

@implementation MaSchViewCell
@synthesize nameString = _nameString;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize bandImgName = _bandImgName;
@synthesize isBandCell = _isBandCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bandImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        nameLabel = [[FXLabel alloc] initWithFrame:CGRectMake(75, 5,190 , 30)];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 120, 25)];
        _isBandCell = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setTimeString
{
    NSMutableString* timeString = [[NSMutableString alloc] init];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    timeFormatter.timeStyle = NSDateFormatterNoStyle;
    timeFormatter.dateFormat = @"H:mm";
    
    NSString *startString = [timeFormatter stringFromDate: _startTime];
    NSString *endString = [timeFormatter stringFromDate: _endTime];
   
    [timeString appendString:startString];
    [timeString appendString:@" ~ "];
    [timeString appendString:endString];
    timeLabel.text = timeString;    
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor =[UIColor grayColor];
    
    [timeLabel sizeToFit];

}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self setTimeString];
    [self addSubview:timeLabel];
    
    nameLabel.text = _nameString;
    [self addSubview:nameLabel];
    nameLabel.shadowColor = [UIColor lightGrayColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:19];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    nameLabel.shadowBlur = 3.0f;

    UIImage* bandImg = [UIImage imageNamed:_bandImgName];
    bandImgView.image = bandImg;
    [self addSubview:bandImgView];
    
    if (! _isBandCell) {    // band cell view
        [timeLabel removeFromSuperview];
        CGRect frame = nameLabel.frame;
        frame.origin.y = 15;
        nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:21];
        nameLabel.frame = frame;
        nameLabel.shadowBlur = 4.0f;

    }
}



@end
