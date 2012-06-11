//
//  MaTableSubtitleItem.m
//  WeiboNote
//
//  Created by Accthun He on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MoreMusicAppDelegate.h"

#import "MaTableSubtitleItemCell.h"
#import "MaTableSubtitleItem.h"
#import "MaMoreMusicDefine.h"
#import "Three20Core/NSDateAdditions.h"

@interface MaTimeLabel : UILabel
{
    NSTimeInterval createTime;
}
@end

@implementation MaTimeLabel

- (id)init
{
    self = [super init];
    if (self) {
        createTime = 0;
        [NSThread detachNewThreadSelector:@selector(updateRelativeTime) toTarget:self withObject:nil];
    }
    
    return self;
}


- (time_t)getTimeValue:(NSString *)stringTime defaultValue:(time_t)defaultValue {
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}


-(void)initWithCreateTime:(double)inTime
{
    createTime = inTime;
//    NSLog(@"%f", createTime);

}

-(void)refreshLabel
{
    NSDate* createdAt =  [NSDate dateWithTimeIntervalSince1970: createTime];
    NSString* dateString = [createdAt formatRelativeTime];
    self.text = dateString;
    
//    NSLog(@"Updating: CreateAt %@ ",dateString);
}

-(void)updateRelativeTime
{
    while(TRUE) {
        [NSThread sleepForTimeInterval:1];
        [self performSelectorOnMainThread:@selector(refreshLabel) withObject:nil waitUntilDone:YES]; 
    }
}

@end



@interface MaTableSubtitleItemCell (pravite)

-(NSString*) getSourceStringform:(NSString*)inString;
-(NSString*) getCommentAndRepostStringBy:(NSString*)commentCount rePostCount:(NSString*)rpCount;
-(NSString*) getCommentStringBy:(NSString*)commMsg withDetail:(NSDictionary*) detail;

@end

@implementation MaTableSubtitleItemCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {    

        UIImage* backgroundImg = [UIImage imageNamed:@"cellBackground"];
        UIImageView* backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImg];
        
        self.backgroundView = backgroundImgView;
        
        // Message Image view init
        _messageImageView = [[TTImageView alloc]initWithFrame:CGRectZero];
        _messageImageView.backgroundColor = [UIColor clearColor];
        _messageImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_messageImageView.autoresizesToImage = YES;

        // Create Time view init
        CGRect rect = CGRectMake(230, BORDER_WIDTH, 80, LABEL_HEIGHT);
        _createTimeLabel = [[MaTimeLabel alloc] init];
        _createTimeLabel.frame = rect;
        _createTimeLabel.font = TTSTYLEVAR(font);
        _createTimeLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _createTimeLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        _createTimeLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _createTimeLabel.textAlignment = UITextAlignmentRight;
        _createTimeLabel.highlightedTextColor = [UIColor whiteColor];
        _createTimeLabel.textColor = [UIColor lightGrayColor];
        _createTimeLabel.opaque = NO;
        _createTimeLabel.backgroundColor = [UIColor clearColor];
        
        // Create Retweet status view init
        _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentCountLabel.font = TTSTYLEVAR(font);
        _commentCountLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _commentCountLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        _commentCountLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _commentCountLabel.textAlignment = UITextAlignmentRight;
        _commentCountLabel.highlightedTextColor = [UIColor whiteColor];
        _commentCountLabel.textColor = [UIColor lightGrayColor];
        _commentCountLabel.opaque = NO;
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_commentCountLabel];

        // Create Source view init
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.font = TTSTYLEVAR(font);
        _sourceLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _sourceLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        _sourceLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _sourceLabel.textAlignment = UITextAlignmentLeft;
        _sourceLabel.highlightedTextColor = [UIColor whiteColor];
        _sourceLabel.textColor = [UIColor lightGrayColor];
        _sourceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_sourceLabel];

        // Comment view init.
        _commentView = [[TTView alloc] initWithFrame:CGRectZero];
        TTShapeStyle* style = [TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:5 
                                                                                  pointLocation:50
                                                                                     pointAngle:90
                                                                                      pointSize:CGSizeMake(20,10)] next:
                               [TTSolidFillStyle styleWithColor:[UIColor lightTextColor] next:
                                [TTSolidBorderStyle styleWithColor:[UIColor lightGrayColor] width:1 next:nil]]];
        _commentView.backgroundColor = [UIColor clearColor];
        _commentView.style = style;
        
        // init comment message label and image
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font =  self.subtitleLabel.font;
        _commentLabel.lineBreakMode = UILineBreakModeWordWrap;
        _commentLabel.numberOfLines = 0;
        _commentLabel.backgroundColor = [UIColor clearColor];
        [_commentView addSubview:_commentLabel];

        _commentImage = [[TTImageView alloc]initWithFrame:CGRectZero];
        _commentImage.backgroundColor = [UIColor lightGrayColor];
        _commentImage.contentMode = UIViewContentModeScaleAspectFit;

        //_commentImage.autoresizesToImage = YES;
        [_commentView addSubview:_commentLabel];
     
        
    }
    
    NSLog(@"MaCell created");
    return self;
}

- (id)getCellDataSource {
	return (MaTableSubtitleItem*)_item;  
}


- (void)setObject:(id)object {

	if (_item != object) {
		[super setObject:object];
		MaTableSubtitleItem *item = object;
        BOOL hasComment = NO;
        NSDictionary* dict =  [item.detailInfo objectForKey:@"value"];

        // Time Label View
        NSString* value = [dict objectForKey:@"time"];
        NSString* timeString = [value substringWithRange:NSMakeRange(0, 10)];
		[_createTimeLabel initWithCreateTime: [timeString doubleValue]];

        [self.contentView addSubview:_createTimeLabel];
        
        // Source Label view
        [_sourceLabel setText: [dict objectForKey:@"source"]];
        
        // Comment Count view
        NSString* commentString = [dict objectForKey:@"comment"];
        NSMutableString* commCount = [[NSMutableString alloc]init];
        if ([commentString length]) {
            commCount = [NSMutableString stringWithString:[dict objectForKey:@"comment"]];
        }
        NSString* rpCount = [dict objectForKey:@"forward"];
        if ([rpCount length]) {
            [commCount appendString:@" "];
            [commCount appendString:rpCount];
        }
        
        NSString* fav = [dict objectForKey:@"favorite"];
        if ([fav length]) {
            [commCount appendString:@" "];
            [commCount appendString:fav];
        }

        [_commentCountLabel setText:commCount];
        [self.contentView addSubview:_commentCountLabel];
        

        // Image View
        if ([item.messageImageURL length] != 0) {
            [_messageImageView setUrlPath:item.messageImageURL];
            [self.contentView addSubview:_messageImageView];
        }
        else{
            [_messageImageView setUrlPath:@""];
            [_messageImageView removeFromSuperview];
        }
        
        // Comment View
        if ([item.retweetMessage length] != 0)             
        {
            NSString* rtMsg = [self getCommentStringBy:item.retweetMessage withDetail:item.detailInfo];
            [_commentLabel setText:rtMsg];
            [_commentView addSubview:_commentLabel];
            [self.contentView addSubview:_commentView];
            hasComment = YES;
        }
        else
        {
            [_commentLabel setText:@""];
            [_commentLabel removeFromSuperview];
        }

        if ([item.retweetMessageImageURL length] != 0) {
            [_commentImage setUrlPath:item.retweetMessageImageURL];
            [_commentView addSubview:_commentImage];
            [self.contentView addSubview:_commentView];
            hasComment = YES;
        }
        else
        {
            [_commentImage setUrlPath:@""];
            [_commentImage removeFromSuperview];
        }
        
        if (!hasComment) {
            [_commentView removeFromSuperview];
        }
        
        //Set deleget
//        MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate]; 
 //       MaTableSubtitleItem* item = [self getCellDataSource];
//        NSString* jsonString = item.jsonType;
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat textWidth = screenWidth - BORDER_WIDTH*4 - IMAGE_SIDE;

    // Adjust User Icon Size & Location.
    if (_imageView2) {
        _imageView2.frame = CGRectMake(BORDER_WIDTH, BORDER_WIDTH, IMAGE_SIDE, IMAGE_SIDE);
    }
    
    if (self.subtitleLabel) {
        self.subtitleLabel.frame = CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, textWidth, LABEL_HEIGHT);
        self.subtitleLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.subtitleLabel.numberOfLines = 0;
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        [self.subtitleLabel sizeToFit];
    }
    
    // Image View size & location
    if (_messageImageView) {
        CGRect msgLableRect = [self.subtitleLabel frame];    
        CGRect rect = CGRectMake(msgLableRect.origin.x , msgLableRect.origin.y + msgLableRect.size.height + BORDER_WIDTH, PICT_SIDE, PICT_SIDE);   
        [_messageImageView setFrame:rect];
        _messageImageView.backgroundColor = [UIColor clearColor];
    }
    
    // Create Time size & location
    if(_createTimeLabel){
    }

    if(self.detailTextLabel){
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.frame = CGRectMake(TEXT_OFFSET_X, BORDER_WIDTH, LABEL_WIDTH, self.textLabel.frame.size.height);
    }
 
    // Calculate Comment label starting point from message body.
    CGRect subTitleRect = self.subtitleLabel.frame;
    
    if (_commentLabel) {
        _commentLabel.frame = CGRectMake(BORDER_WIDTH, BORDER_WIDTH*3 , textWidth - BORDER_WIDTH*2 , LABEL_HEIGHT);
        _commentLabel.lineBreakMode = UILineBreakModeWordWrap;
        _commentLabel.numberOfLines = 0;
        
        [_commentLabel sizeToFit];
    }
    
    if ([_commentImage.urlPath length] != 0) {
        // Calculate Comment image starting point from comment label  body.
        CGRect commentLabelRect = _commentLabel.frame;
        _commentImage.frame = CGRectMake(BORDER_WIDTH, commentLabelRect.origin.y+commentLabelRect.size.height+BORDER_WIDTH, PICT_SIDE, PICT_SIDE);
    }
    
    if (_commentView) {
        CGFloat viewHeight;
        if ([_commentImage.urlPath length] == 0) 
            viewHeight = _commentLabel.frame.size.height + COMMENTVIEW_BORDER  ;
        else
            viewHeight = _commentLabel.frame.size.height + PICT_SIDE + COMMENTVIEW_BORDER ;
        
        _commentView.frame = CGRectMake(TEXT_OFFSET_X, subTitleRect.origin.y+ subTitleRect.size.height + BORDER_WIDTH , textWidth , viewHeight);
        // Calculate Comment view height form comment message body;  
    }
    
    CGFloat buttomItemOriginY;
    buttomItemOriginY = subTitleRect.origin.y + subTitleRect.size.height ;
    
    if ([_messageImageView.urlPath length] != 0) {
        buttomItemOriginY = buttomItemOriginY + PICT_SIDE + BORDER_WIDTH ;
    }
    
    
    if ([_commentLabel.text length] != 0 ) {
        buttomItemOriginY = _commentView.frame.origin.y + _commentView.frame.size.height;
    }
    
    if (_sourceLabel) {
        _sourceLabel.frame = CGRectMake(TEXT_OFFSET_X, buttomItemOriginY , _commentView.frame.size.width * 0.4 - 1 , LABEL_HEIGHT);
        _sourceLabel.font = _commentCountLabel.font;
    }
    
    if (_commentCountLabel) {
        _commentCountLabel.frame = CGRectMake(TEXT_OFFSET_X + _sourceLabel.frame.size.width + 2, buttomItemOriginY, _commentView.frame.size.width - _sourceLabel.frame.size.width - 2, LABEL_HEIGHT);
        //[_commentCountLabel sizeToFit];
        _commentCountLabel.font = [UIFont systemFontOfSize:9];
        _commentCountLabel.textAlignment = UITextAlignmentRight;
    }
}


+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {  
    CGFloat result = 0;
    MaTableSubtitleItem *customItem = item;
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    CGFloat textWidth = screenBounds.size.width - BORDER_WIDTH*4 - IMAGE_SIDE;
    
 // Don't create cell to get font info~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~ Profromance Issue ?
    TTTableSubtitleItemCell *theCell = [[TTTableSubtitleItemCell alloc]init];
    
    // Calculate Message body size
    UIFont *subFont = theCell.subtitleLabel.font;
    CGSize subtitleSize = [customItem.subtitle sizeWithFont:subFont  constrainedToSize:CGSizeMake(textWidth,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];

    // Calculate UserName View size
    UIFont *textFont = theCell.textLabel.font;
    CGSize textSize = [customItem.text sizeWithFont:textFont constrainedToSize:CGSizeMake(textWidth,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize commentSize = CGSizeZero;
    // Calculate Comment body size     // Increace Space for Comment View
    if ([customItem.retweetMessage length] != 0) {
        
        NSDictionary* retweets = [customItem.detailInfo objectForKey:@"retweeted_status"]; 
        NSDictionary* user = [retweets objectForKey:@"user"];
        NSString* displayName = [user objectForKey:@"screen_name"] ;
        NSMutableString* rtMsg =  [[NSMutableString alloc]init];
        if(displayName)
        {
            [rtMsg appendString:displayName];
            [rtMsg appendString:@": "];
        }
            
        [rtMsg appendString:customItem.retweetMessage];
        UIFont *textFont = theCell.subtitleLabel.font;
        commentSize = [rtMsg sizeWithFont:textFont constrainedToSize:CGSizeMake(textWidth - BORDER_WIDTH*2,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        result = commentSize.height + CELLWITHCOMMENTVIEW_BORDER ;
    }    
    result = subtitleSize.height + textSize.height + BORDER_WIDTH*3 + result;

    // Increace Space for Message Image.
    if ([customItem.messageImageURL length] != 0)
        result = result + BORDER_WIDTH*2 + PICT_SIDE;
    
    // Increace Space for Comment Image.----------------------------- Coding Here!!!!!!
    if ([customItem.retweetMessageImageURL length] != 0)
        result = result + PICT_SIDE;
    // TODO: need a better solution
    // Increace Space for Source Lable
    if ([customItem.retweetMessage length] != 0) 
    {
        result += NEW_LABEL_HEIGHT;
    }
    else if ([customItem.messageImageURL length] != 0) 
    {
        result += 10;
    }
    else 
    {
        result += 15;
    }
    
    if (result < ROW_HEIGHT) 
        result = ROW_HEIGHT;  
    
	return result;
}

-(NSString*) getSourceStringform:(NSString*)inString
{
//    <a href="http://desktop.weibo.com/?source=app" rel="nofollow">XXXXXXX</a>
//                                                                  ^startingRange.location + 1
//                                                                  XXXXXXX ----> String we wanted
//                                                                         ^substing.length - 4
//                                                              
    NSRange startRange = [inString rangeOfString:@">"];
    
    NSString* subString = [inString substringFromIndex:startRange.location+1];
    NSString* result = [subString substringToIndex:subString.length-4];

    return result;
}

-(NSString*) getCommentAndRepostStringBy:(NSString*)commentCount rePostCount:(NSString*)rpCount
{
    NSMutableString* result = [[NSMutableString alloc]initWithString:@""];
    NSInteger commValue, rpValue = 0;
    commValue = [commentCount intValue];
    rpValue = [rpCount intValue];

    if (commValue != 0 || rpValue != 0)
    {
        [result setString: @"Comment: "];
        NSString *strCommValue = [NSString stringWithFormat:@"%d", commValue];
        [result appendString:strCommValue];
        
        NSString* rePostString = @" | Repost:";
        NSString *strRpValue = [NSString stringWithFormat:@"%d", rpValue];

        [result appendString:rePostString];
        [result appendString:strRpValue];

    }
        
    return result;

}

-(NSString*) getCommentStringBy:(NSString*)commMsg withDetail:(NSDictionary*) detail
{
    //------------------- Need change codes in tableView getHeight!!!!!!!!!!--------------
    NSDictionary* retweets = [detail objectForKey:@"retweeted_status"]; 
    NSDictionary* user = [retweets objectForKey:@"user"];
    NSString* displayName = [user objectForKey:@"screen_name"] ;
    NSMutableString* result =  [[NSMutableString alloc]init];
    if(displayName)
    {
        [result appendString:displayName];
        [result appendString:@": "];
    }
    
    [result appendString:commMsg];
    
    return result;
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point=[touch locationInView:self];

    if (([touch view] == _imageView2) ||(CGRectContainsPoint([self.textLabel frame],point)))
    {
        [self pushProfileViewController];
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}
*/
-(void)setTarget:(id)target andAction:(SEL)action {
    delegate = target;
    touchAction = action;
}

/*
-(void)pushProfileViewController {
    MaTableSubtitleItem*  item = [self getCellDataSource];
    NSDictionary* profileDict = [item.detailInfo objectForKey:@"user"]; 

    if (delegate && [delegate respondsToSelector:touchAction]) {
        [delegate performSelector:touchAction withObject: profileDict];
    }
}

*/
- (void)setParentTableView:(id)tableView;
{
    parentTableView = tableView;
}


@end
