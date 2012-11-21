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
#import "WBUtil.h"

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

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more 
{
    
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
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* pageString = [[NSNumber numberWithInt:_page] stringValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];

    NSString *topicString = NSLocalizedString(@"TopicTag",nil) ;
    [params setObject:(topicString ? topicString : @"") forKey:@"q"];
    [params setObject:(pageString ? pageString : @"") forKey:@"page"];
    

    WBRequest* wbReq = [app.authMgr.currentEngine getRequestWithMethodName:_requestString
                                                                httpMethod:@"GET"
                                                                    params:params
                                                              postDataType:kWBRequestPostDataTypeNone
                                                          httpHeaderFields:nil];
    if (wbReq)
    {    
        NSString *urlString = [WBRequest serializeURL:wbReq.url params:wbReq.params httpMethod:@"GET"];
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

}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = response.rootObject;
    
    TTDASSERT([[feed objectForKey:@"statuses"] isKindOfClass:[NSArray class]]);
    
    NSArray* entries = [feed objectForKey:@"statuses"];
    
 //   NSLog(@"%@",entries);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZ"];
    
    _finished = entries.count < _resultsPerPage;
    
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
