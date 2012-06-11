//
//  MaUniDataModel.m
//  WeiboNote
//
//  Created by Accthun He on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaUniDataModel.h"
#import "MoreMusicAppDelegate.h"
#import "MaAuthMgr.h"
#import "extThree20JSON/extThree20JSON.h"
#import "WBErrorNoticeView.h"

@implementation MaUniDataModel
@synthesize messages          = _messages;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;


- (id)initRequestWithString:(NSString*) reqString {
    if (self = [super init]) {

        _requestString = reqString;
        _resultsPerPage = 16;
        _page = 1;
        _messages = [NSMutableArray array];
        engineExp = NO;
    }
    return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    // Weibo engine will check status if expired before sending requests...
    
    if (!self.isLoading) {
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_messages removeAllObjects];
        }  
    }
    NSString* serverString = @"http://173.254.214.47:5984/weibo/_design/weibo/_view/weibo?limit=16";
    NSInteger skipCount = _page*_resultsPerPage;
    if (_page==1) {
        skipCount = 0;
    }
    
    NSString *skipItemCount = [NSString stringWithFormat:@"%d", skipCount];
    NSMutableString* urlString = [NSMutableString stringWithString:serverString];
    [urlString appendString:@"&skip="];
    [urlString appendString:skipItemCount];


 //   NSString *urlString = [WBRequest serializeURL:wbReq.url params:wbReq.params httpMethod:@"GET"];
    NSLog(@"URL Request Connecting...\n %@ ", urlString);

    TTURLRequest* request = [TTURLRequest
                             requestWithURL: urlString
                             delegate: self];

    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.httpMethod = @"GET";
//        request.headers = wbReq.httpHeaderFields;
    // set headers from http headerFields
    
    
    
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
//    TT_RELEASE_SAFELY(response);
    
    [request send];


}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = response.rootObject;
    
    TTDASSERT([[feed objectForKey:@"rows"] isKindOfClass:[NSArray class]]);
    
    NSArray* entries = [feed objectForKey:@"rows"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZ"];
    
    _finished = entries.count < _resultsPerPage;

//    NSLog(@"%@", entries);
    [_messages addObjectsFromArray: entries];
        
    [super requestDidFinishLoad:request];

}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];

//    engineExp = YES;
    NSDictionary* dict = error.userInfo;
    NSData* data = [dict valueForKey:@"responsedata"];
    NSError* errorResult;
    [WBRequest parseJSONData:data error:&errorResult];
    
    NSDictionary* resultDict = errorResult.userInfo;
    id errorCode = [resultDict valueForKey:@"error_code"];
    NSString* errorString =[NSString stringWithFormat:@"%d", [errorCode intValue]];
    
    NSMutableString* errorMessage = [[NSMutableString alloc] initWithString:NSLocalizedString(@"WeiboLoadFailed",nil)];
    
    [errorMessage appendString:errorString];
    
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:app.window title:NSLocalizedString(@"ERROR",nil) message:errorMessage];
    
    [notice show];
        
 //   [app.authMgr.currentEngine logIn];
    
    [super didFailLoadWithError:error];
}



@end
