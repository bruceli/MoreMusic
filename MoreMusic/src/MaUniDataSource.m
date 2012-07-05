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
        NSString *msgText = [detail objectForKey:@"text"];
        // User tweets image
        NSString *msgImageURL = [detail objectForKey:@"thumbnail_pic"];
        // User tweets create time
        NSString *strTime = [detail objectForKey:@"created_at"];
        //        NSTimeInterval crtTime = [self getTimeValue:strTime defaultValue:0];
        //        NSDate *createdAt =  [NSDate dateWithTimeIntervalSince1970: crtTime];
        
        //------------------ 
        // User Info
        //------------------ 
        NSDictionary* user = [detail objectForKey:@"user"];
        NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
        NSString *screenName = [user objectForKey:@"screen_name"];
        
        //------------------ 
        // Retweets Info
        //------------------ 
        NSDictionary* retweets = [detail objectForKey:@"retweeted_status"];; 
        NSString* retweetImgURL = [retweets objectForKey:@"thumbnail_pic"];
        NSString* retweetMsgText = [retweets objectForKey:@"text"];
        
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
