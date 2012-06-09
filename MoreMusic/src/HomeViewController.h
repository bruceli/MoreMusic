//
//  HomeViewController.h
//  WeiboNote
//
//  Created by Zihan He on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MaMessageListController.h"
#import "MaPostController.h"

@interface HomeViewController : MaMessageListController
{

    WBEngine* engine;

}
//- (void)loadMessagesAtPage:(int)numPage count:(int)count;
- (void)reloadTimeLine;
@end
