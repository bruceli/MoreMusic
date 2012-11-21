//
//  MaUniDataModel.h
//  WeiboNote
//
//  Created by Accthun He on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface MaUniDataModel : TTURLRequestModel
{
    NSMutableArray*  _messages;
    NSString* _requestString;
    NSUInteger _page;             // page of search request
    NSUInteger _resultsPerPage;   // results per page, once the initial query is made
    // this value shouldn't be changed
    BOOL _finished;
    BOOL engineExp;
    
}
- (id)initRequestWithString:(NSString*) reqString;
@property (nonatomic, readonly) NSMutableArray* messages;
@property (nonatomic, assign)   NSUInteger      resultsPerPage;
@property (nonatomic, readonly) BOOL            finished;


@end
