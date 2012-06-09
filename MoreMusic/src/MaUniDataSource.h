//
//  MaUniDataSource.h
//  WeiboNote
//
//  Created by Accthun He on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "MaUniDataModel.h"

@interface MaUniDataSource : TTListDataSource
{
    NSMutableArray* messages;
//    MaMentionsDataModel* mentionsModel;
    MaUniDataModel* uniModel;
    NSString* requestJSON;
}
@property (nonatomic, retain)     NSString* requestJSON;

-(void) initDataModelWithRequestJSON:(NSString*)inJSON;

@end
