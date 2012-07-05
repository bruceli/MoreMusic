//
//  MaAuthMgr.m
//  WeiboNote
//
//  Created by Accthun He on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaAuthMgr.h"
#import "MoreMusicAppDelegate.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
@implementation MaAuthMgr

@synthesize currentEngine;

- (id)init {

	if (self = [super init]) {
    }    
    currentEngine = [[WBEngine alloc] initWithAppKey:kOAuthConsumerKey appSecret:kOAuthConsumerSecret];
    
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    [currentEngine setRootViewController:app.weiboStreamViewController];
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
    [currentEngine logOut];
}


-(void)clearCookie
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies)
    {   
        NSString* domain = [each domain];
        if([domain rangeOfString:@"sina"].location == NSNotFound &&
           [domain rangeOfString:@"weibo"].location == NSNotFound)
            continue;
        [cookieStorage deleteCookie:each];
        NSLog(@"Deleting cookie %@", each);
    }
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize



- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{

}

- (void)engineDidLogIn:(WBEngine *)engine
{
    //Login successful. 
    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:app.window title:NSLocalizedString(@"WeiboLoginSuccess",nil)];
    [notice show];

    [app.weiboStreamViewController updateLoginButtonStatus];
    [app.weiboStreamViewController reloadTimeLine];

}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);

    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:app.window title:NSLocalizedString(@"ERROR",nil) message:NSLocalizedString(@"WeiboLoginFailed",nil)];
    [notice show];

}

- (void)engineDidLogOut:(WBEngine *)engine
{    
    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];

    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:app.window title:NSLocalizedString(@"WeiboLogoutSuccess",nil)];
    [notice show];
//    currentEngine = nil;
    [self clearCookie];
    //Login successful. 
    //    [engineArray addObject:engine];
    [app.weiboStreamViewController updateLoginButtonStatus];

}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    [currentEngine logOut];
    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];

    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:app.window title:NSLocalizedString(@"ERROR",nil) message:NSLocalizedString(@"WeiboNeedLogin",nil)];
    
    [notice show];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:app.window title:NSLocalizedString(@"WeiboSendSuccessed",nil)];
    
    [notice show];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{   
    
    NSDictionary* dict = error.userInfo;
    id errorCode = [dict valueForKey:@"error_code"];
    
    MoreMusicAppDelegate *app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* errorString =[NSString stringWithFormat:@"%d", [errorCode intValue]];

    NSMutableString* errorMessage = [[NSMutableString alloc] initWithString:NSLocalizedString(@"WeiboSendFailed",nil)];
    
    [errorMessage appendString:errorString];
    
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:app.window title:NSLocalizedString(@"ERROR",nil) message:errorMessage];

    [notice show];

//    [JHNotificationManager notificationWithMessage: errorString status:NO];
}

@end
