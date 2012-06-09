//
//  MaTableSubtitleItem.h
//  WeiboNote
//
//  Created by Accthun He on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"

@interface MaTableSubtitleItem : TTTableSubtitleItem
{
	NSString* _creatTime;
    NSString* _messageImageURL;
    NSString* _retweetMessage;
    NSString* _retweetMessageImageURL;
    NSDictionary* _detailInfo;
    NSString* _jsonType;
}
@property (nonatomic, copy) NSString *creatTime;
@property (nonatomic, copy) NSString *messageImageURL;
@property (nonatomic, copy) NSString *retweetMessage;
@property (nonatomic, copy) NSString *retweetMessageImageURL;
@property (nonatomic, copy) NSDictionary *detailInfo;
@property (nonatomic, copy) NSString *jsonType;


+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL messageImageURL:(NSString*)msgImageURL createTime:(NSString*)createTime detail:(NSDictionary*)inDetailInfo json:(NSString*)jsonType;
+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL messageImageURL:(NSString*)msgImageURL createTime:(NSString*)createTime retweetMessage:(NSString*)retweetMsgText retweetImageURL:(NSString*)retweetImgURL detail:(NSDictionary*)inDetailInfo json:(NSString*)jsonType;



@end
