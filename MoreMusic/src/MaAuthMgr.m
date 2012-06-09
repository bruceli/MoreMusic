//
//  MaAuthMgr.m
//  WeiboNote
//
//  Created by Accthun He on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaAuthMgr.h"
#import "MoreMusicAppDelegate.h"


@implementation MaAuthMgr

@synthesize currentEngine;

- (id)init {

	if (self = [super init]) {
        if (engineArray == nil) {
            engineArray = [[NSMutableArray alloc] init];
        }
        
        if (tokenArray == nil) {
            tokenArray = [[NSMutableArray alloc] init];
        }
        
        // for XAuth
        if (userPSDArray == nil) {
            userPSDArray = [[NSMutableArray alloc] init];
        }
    }

    currentEngine = [[WBEngine alloc] initWithAppKey:kOAuthConsumerKey appSecret:kOAuthConsumerSecret];
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [currentEngine setRootViewController:app.homeViewController];
    [currentEngine setDelegate:self];
    [currentEngine setRedirectURI:@"http://"];
    [currentEngine setIsUserExclusive:NO];
    
    return self;
}

-(BOOL)isEngineReady
{
    BOOL stats = YES;
    
    if (![currentEngine isLoggedIn] || [currentEngine isAuthorizeExpired])
        stats = NO;

    return stats;
}


-(void)addAccount
{
    [currentEngine logIn];
}

-(void)getDefaultAccount
{
    
}

-(void)logoutAccount
{

}


#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

-(void)removeCurrentEngine
{
    [engineArray removeObject:currentEngine];
}



- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    //Login successful. 
    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    [engineArray addObject:engine];
    [app.homeViewController reloadTimeLine];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
//    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
    
    [engineArray removeObject:engine];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
//    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[self removeCurrentEngine];
    [self addAccount];
//    [app.homeViewController reloadTimeLine];
    
}
/*
#pragma mark - WBAuthorizeDelegate Methods

- (void)authorize:(WBAuthorize *)authorize didSucceedWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresIn:(NSInteger)seconds
{
}

- (void)authorize:(WBAuthorize *)authorize didFailWithError:(NSError *)error
{
}

#pragma mark - WBRequestDelegate Methods
 
 */
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
//    [JHNotificationManager notificationWithMessage: @"Sent" status:YES];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{   
    NSDictionary* dict = error.userInfo;
    id errorCode = [dict valueForKey:@"error_code"];
    NSString* errorString =[NSString stringWithFormat:@"Error Code  %d", [errorCode intValue]];

//    [JHNotificationManager notificationWithMessage: errorString status:NO];
}

+(void)newMessageNotification:(NSInteger)messageCount messageType:(NSInteger)type
{
    NSString* notiString ;
    
    switch (type) {
        case MaMessageType_TimeLine:
            notiString = @"%d New Message";
            break;
            
        case MaMessageType_Mention:
            notiString = @"%d New Mention";
            break;
            
        case MaMessageType_Comment:
            notiString = @"%d New Comment";
            break;
            
        default:
            notiString = @"%d New Message";
            break;
    }
    
    NSString* message =[NSString stringWithFormat:notiString, messageCount];
//    [JHNotificationManager notificationWithMessage: message status:YES];
}


@end
