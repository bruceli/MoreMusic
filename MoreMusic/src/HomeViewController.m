//
//  HomeViewController.m
//  WeiboNote
//
//  Created by Zihan He on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "HomeViewController.h"
#import "MoreMusicAppDelegate.h"
#import "MaUniDataSource.h"
#import "MaTableSubtitleItemCell.h"
#import "MaTableSubtitleItem.h"
#import "MaAuthMgr.h"

@interface HomeViewController()
-(void)repostMessageWithWeiboID:(NSNumber*)idNumber;
-(void)favoMessageWithWeiboID:idNumber withStatus:(NSNumber*)favStatus;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.variableHeightRows = YES;
       self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;  

       // comment this to see how the table looks with the standard style
        self.tableViewStyle = UITableViewStylePlain;

   }
    return self;
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self setupSwipeCell];

    self.navigationItem.title = @"Home";
    
	self.variableHeightRows = YES;  

    UIBarButtonItem *newMsgButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage:)];
    
    self.navigationItem.rightBarButtonItem = newMsgButton;
    
	UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTimeLine)];
    
	self.navigationItem.leftBarButtonItem = reloadButton;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.welcomeViewController showBar];
    
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
 //   MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
 //   [app.welcomeViewController hideBar];

    [super viewDidDisappear:animated];
    
}

-(void)setupSwipeCell
{
    // Setup the title and image for each button within the side swipe view
    buttonData = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Reply", @"title", @"reply.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Retweet", @"title", @"retweet-outline-button-item.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Favorite", @"title", @"star-hollow.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Profile", @"title", @"person.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Links", @"title", @"paperclip.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Action", @"title", @"action.png", @"image", nil],
                  nil];
    buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.rowHeight)];
    [super setupSideSwipeView];
    
}

- (void) touchUpInsideAction:(UIButton*)button
{
    NSIndexPath* indexPath = [_tableView indexPathForCell:sideSwipeCell];
    MaTableSubtitleItemCell *cell = (MaTableSubtitleItemCell*)[_tableView cellForRowAtIndexPath:indexPath];
    MaTableSubtitleItem* cellItem = (MaTableSubtitleItem*)[cell getCellDataSource];
    
    NSNumber* idNumber =  [cellItem.detailInfo objectForKey:@"id"];
    NSNumber* stat = [cellItem.detailInfo objectForKey:@"favorited"];
    
    //NSString* cl = [stat  className];
    NSUInteger index = [buttons indexOfObject:button];

//    NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
//    Get button info if needed;
    
    switch (index) {
        case MaReplayButton:
            //[engine repostWithWeiboID:idNumber message:@"RE:"];
            [self repostMessageWithWeiboID:idNumber];
            
            ;
            break;
            
        case MaRePostButton:
            ;
            break;
            
        case MaFavoriteButton:
            [self favoMessageWithWeiboID:idNumber withStatus:stat];
            break;
            
    
        default:
            break;
    }
        
    [self removeSideSwipeView:YES];
}

#pragma mark Generate images with given fi

-(void)reloadTimeLine
{
    [self.model load:TTURLRequestCachePolicyNetwork more:NO];
    [self becomeFirstResponder];
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)createModel
{ 
//    self.dataSource = [[MaWeiboDataSource alloc] init];
    
    MaUniDataSource* dataSource = [[MaUniDataSource alloc] init];
 //   [dataSource initDataModelWithRequestJSON:@"statuses/home_timeline.json"];
    [dataSource initDataModelWithRequestJSON:JSON_STAT_HOME_TIMELINE];  

    
    self.dataSource = dataSource;
}


- (id<UITableViewDelegate>)createDelegate {
    return [[TTTableViewDragRefreshDelegate alloc] initWithController:self];
}


- (void)loadMessagesAtPage:(int)numPage count:(int)count;
{

}

#pragma mark - New Message 

- (void)newMessage:(NSDictionary*)query {
    

    MaPostController* postViewController = [[MaPostController alloc] init];
    UINavigationController *postNavController = [[UINavigationController alloc] initWithRootViewController:postViewController];
    postViewController.msgType = MaSendMessageType_Post;
    postNavController.navigationItem.title = @"Post Message";

    [self presentModalViewController:postNavController animated:YES];
    
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.welcomeViewController hideBar];
    


}



#pragma mark - New Repost 

-(void)repostMessageWithWeiboID:(NSNumber*)idNumber
{
    MaPostController* postViewController = [[MaPostController alloc] init];
    UINavigationController *postNavController = [[UINavigationController alloc] initWithRootViewController:postViewController];
    postViewController.weiboID = idNumber;
    postViewController.msgType = MaSendMessageType_RePost;
    
    [self presentModalViewController:postNavController animated:YES];

    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.welcomeViewController hideBar];
    

}

#pragma mark - Favorites

-(void)favoMessageWithWeiboID:idNumber withStatus:(NSNumber*)favStatus
{
    BOOL isFav = NO;
    if ([favStatus intValue]) {
        isFav = YES;
    }
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    MaAuthMgr* authMgr = app.authMgr;
    engine = authMgr.currentEngine;

    [engine favoritMessageWithWeiboID:idNumber withStatus:isFav];
}

#pragma mark - ProfileView 



@end
