//
//  MaTableSubtitleItem.m
//  WeiboNote
//
//  Created by Accthun He on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaTableSubtitleItem.h"

@implementation MaTableSubtitleItem

@synthesize creatTime = _creatTime;
@synthesize messageImageURL = _messageImageURL;
@synthesize retweetMessage = _retweetMessage;
@synthesize retweetMessageImageURL = _retweetMessageImageURL;
@synthesize detailInfo = _detailInfo;
@synthesize jsonType = _jsonType;

- (id)init
{
    self = [super init];
    if (self) {
        _creatTime = nil;
		_messageImageURL = nil;
        _retweetMessage = nil;
        _retweetMessageImageURL = nil;
        _detailInfo = nil;
        _jsonType = nil;
    }
    
    return self;
}

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL messageImageURL:(NSString*)msgImageURL createTime:(NSString*)createTime detail:(NSDictionary*)inDetailInfo json:(NSString*)jsonType
{
    MaTableSubtitleItem* item = [[self alloc] init];
    UIImage* defaultPerson = TTIMAGE(@"bundle://defaultPerson.png");
    item.text = text;
    item.subtitle = subtitle;
    item.imageURL = imageURL;
    item.messageImageURL = msgImageURL;
    item.creatTime = createTime;
    item.defaultImage = defaultPerson;
    item.retweetMessage = nil;
    item.retweetMessageImageURL = nil;
    item.detailInfo = inDetailInfo;
    item.jsonType = jsonType;
   // item.URL = @"tt://detailMessageView";

    return item;
}

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL messageImageURL:(NSString*)msgImageURL createTime:(NSString*)createTime retweetMessage:(NSString*)retweetMsgText retweetImageURL:(NSString*)retweetImgURL detail:(NSDictionary*)inDetailInfo json:(NSString*)jsonType;
{
    MaTableSubtitleItem* item = [[self alloc] init];
    UIImage* defaultPerson = TTIMAGE(@"bundle://defaultPerson.png");
    item.text = text;
    item.subtitle = subtitle;
    item.imageURL = imageURL;
    item.messageImageURL = msgImageURL;
    item.creatTime = createTime;
    item.defaultImage = defaultPerson;
    item.retweetMessage = retweetMsgText;
    item.retweetMessageImageURL = retweetImgURL;
    item.detailInfo = inDetailInfo;
    item.jsonType = jsonType;
  //  item.URL = @"tt://detailMessageView";

    return item;
}

#pragma mark -
#pragma mark NSCoding
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [super initWithCoder:decoder];
    if (self) {
        _creatTime = [decoder decodeObjectForKey:@"createTime"];
        _messageImageURL = [decoder decodeObjectForKey:@"msgImageURL"];
        _detailInfo = [decoder decodeObjectForKey:@"detailInfo"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    if (self.subtitle) {
        [encoder encodeObject:self.subtitle forKey:@"createTime"];
    }
    if (self.imageURL) {
        [encoder encodeObject:self.imageURL forKey:@"msgImageURL"];
    }
    if (self.detailInfo) {
        [encoder encodeObject:self.imageURL forKey:@"detailInfo"];
    }

}


@end
