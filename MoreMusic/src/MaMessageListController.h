//
//  MaMessageListController.h
//  WeiboNote
//
//  Created by Zihan He on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "Three20UI/UITableViewAdditions.h"

@class TBTabButton;

@interface MaMessageListController : TTTableViewController
{
	NSMutableArray*  _messages;
    BOOL            _loading;
	NSString*        _errorDesc;
    
    NSOperationQueue *operationQueue;
    
    NSMutableArray* userIconArray;
    
    TBTabButton *tabBarButton;
    CGPoint _lastSwipeStartPoint;
    
    UITableViewCell* sideSwipeCell;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    BOOL animatingSideSwipe;
    UIView* sideSwipeView;
    UIImageView* swipeOutContentView;
    
    NSArray* buttonData;
    NSMutableArray* buttons;
    
    CGPoint touchPoint;
    NSMutableArray* _favArray;
}

@property (retain) TBTabButton *tabBarButton;
@property (nonatomic, retain) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;
@property (nonatomic, retain) UIView* sideSwipeView;
@property (nonatomic, retain) NSMutableArray* favArray;

- (void)openAuthenticateView;
- (void)loadMessagesAtPage:(int)numPage count:(int)count;

- (void) setupSideSwipeView;
- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;
- (void) reloadTimeLine;


@end
