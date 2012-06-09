//
//  MaAuthMgr.h
//  WeiboNote
//
//  Created by Accthun He on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBEngine.h"
#import "MaMoreMusicDefine.h"

@interface MaAuthMgr : NSObject <WBEngineDelegate>
{
    WBEngine* currentEngine;
    NSMutableArray* engineArray;
    NSMutableArray* tokenArray;
    NSMutableArray* userPSDArray;
    
}
@property (nonatomic, readonly) WBEngine* currentEngine;

-(void)addAccount;
-(BOOL)isEngineReady;
-(void)engineAuthorizeExpired:(WBEngine *)engine;
+(void)newMessageNotification:(NSInteger)messageCount messageType:(NSInteger)type;

@end
