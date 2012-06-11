//
//  MaUniDataSource.m
//  WeiboNote
//
//  Created by Accthun He on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaUniDataSource.h"
#import "MaTableSubtitleItem.h"
#import "MaTableSubtitleItemCell.h"
#import "MoreMusicAppDelegate.h"
#import "MaAuthMgr.h"
#import "MaMoreMusicDefine.h"

@interface MaUniDataSource (Private)
- (void)loadTimeline;
- (time_t)getTimeValue:(NSString *)stringTime defaultValue:(time_t)defaultValue;
@end

@implementation MaUniDataSource
@synthesize requestJSON;

- (id)init {

	if (self = [super init]) {
        if (!messages) 
            messages = [[NSMutableArray alloc] init];
	}
   // app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

	return self;
}

-(void) initDataModelWithRequestJSON:(NSString*)inJSON
{
    requestJSON = inJSON;
    uniModel = [[MaUniDataModel alloc] initRequestWithString:inJSON];
}


- (id <TTModel>) model {
    return uniModel;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {

    NSMutableArray* items = [[NSMutableArray alloc] init];

    for (NSDictionary *detail in uniModel.messages) {
        //------------------ 
        // Message Info
        //------------------ 
        // User tweets text
        NSDictionary* value = [detail objectForKey:@"value"];

        
        NSString *msgText = [value objectForKey:@"weibo"];
        // User tweets image
        NSString *msgImageURL = [value objectForKey:@"weibo_image"];
        // User tweets create time
        NSString *strTime = [value objectForKey:@"time"];
//        NSLog(@"%@" ,strTime);
//        NSTimeInterval crtTime = [self getTimeValue:strTime defaultValue:0];
//        NSDate *createdAt =  [NSDate dateWithTimeIntervalSince1970: crtTime];
       
        //------------------ 
        // User Info
        //------------------ 
        NSString *profileImageUrl = [value objectForKey:@"user_image"];
        NSString *screenName = [value objectForKey:@"user_title"];
        
        //------------------ 
        // Retweets Info
        //------------------ 
        NSDictionary* retweets = [value objectForKey:@"forward_weibo"];; 
        NSString* retweetImgURL = [retweets objectForKey:@"img"];
        NSString* retweetMsgText = [retweets objectForKey:@"weibo"];
        
        MaTableSubtitleItem * cellItem;
        if (retweets) {
            cellItem = [MaTableSubtitleItem itemWithText:screenName subtitle:msgText imageURL:profileImageUrl messageImageURL: msgImageURL createTime:strTime retweetMessage:retweetMsgText retweetImageURL:retweetImgURL detail:detail json:requestJSON];

        }
        else{
            cellItem = [MaTableSubtitleItem itemWithText:screenName subtitle:msgText imageURL:profileImageUrl messageImageURL: msgImageURL createTime:strTime detail:detail json:requestJSON];
        }
        [items addObject:cellItem];

    }
    
    TTTableMoreButton *button = [TTTableMoreButton itemWithText:NSLocalizedString(@"LoadMore",nil)];
    [items addObject:button];
                                 
    self.items = items;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    if (reloading) {
        return NSLocalizedString(@"WeiboUpdating", @"Twitter feed updating text");
    } else {
        return NSLocalizedString(@"WeiboLoading", @"Twitter feed loading text");
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
    return NSLocalizedString(@"WeiboNotFound", @"Twitter feed no results");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
    return NSLocalizedString(@"WeiboError", @"");
}


//=============================================================================================================================

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
    if ([object isKindOfClass:[MaTableSubtitleItem class]]) {
        return [MaTableSubtitleItemCell class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

//=============================================================================================================================

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

-(void)newItemNotification:(NSInteger)count
{
/*    if ([requestJSON isEqualToString:@"statuses/mentions.json"]) 
        [MaAuthMgr newMessageNotification:count messageType:MaMessageType_Mention];
    else if ([requestJSON isEqualToString:@"statuses/home_timeline.json"]) 
        [MaAuthMgr newMessageNotification:count messageType:MaMessageType_TimeLine];
  */      
}



@end
