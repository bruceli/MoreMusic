//
//  HomeViewController.m
//  WeiboNote
//
//  Created by Zihan He on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MaWeiboStreamViewController.h"
#import "MoreMusicAppDelegate.h"
#import "MaUniDataSource.h"
#import "MaTableSubtitleItemCell.h"
#import "MaTableSubtitleItem.h"
#import "MaAuthMgr.h"

@interface MaWeiboStreamViewController()
-(void)repostMessageWithWeiboID:(NSNumber*)idNumber;
-(void)commentMessageWithWeiboID:(NSNumber*)idNumber;
-(void)favoMessageWithWeiboID:idNumber withStatus:(NSNumber*)favStatus;
-(void)login;
-(void)removeSwipeCell;

@end

@implementation MaWeiboStreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.variableHeightRows = YES;
       self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;  
       self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Weibo",nil) image:[UIImage imageNamed:@"weibo"] tag:0];

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

    self.navigationItem.title = NSLocalizedString(@"Weibo",nil);
    
	self.variableHeightRows = YES;  
    
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateLoginButtonStatus];

    
   //     [app.welcomeViewController showBar];

    

}

-(void)updateLoginButtonStatus
{
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![app.authMgr isEngineReady]) {
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login",nil) style:UIBarButtonItemStylePlain target:self action:@selector(login)];
        self.navigationItem.rightBarButtonItem = nil;
        [self removeSwipeCell];
    }
    else {
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout",nil) style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage:)];
        [self setupSwipeCell];
    }

}
-(void)login
{
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.authMgr addAccount];
    
    [self updateLoginButtonStatus];
}

-(void)logout
{
    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.authMgr logoutAccount];
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
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Repost", @"title", @"repost.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Comment", @"title", @"comment.png", @"image", nil],
                  nil];
    buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.rowHeight)];
    [super setupSideSwipeView];
}

-(void)removeSwipeCell
{
    self.sideSwipeView = nil;
    [super setupSideSwipeView];
}

- (void) touchUpInsideAction:(UIButton*)button
{
    NSIndexPath* indexPath = [_tableView indexPathForCell:sideSwipeCell];
    MaTableSubtitleItemCell *cell = (MaTableSubtitleItemCell*)[_tableView cellForRowAtIndexPath:indexPath];
    MaTableSubtitleItem* cellItem = (MaTableSubtitleItem*)[cell getCellDataSource];
    
    
    NSDictionary* dict = [cellItem.detailInfo objectForKey:@"value"];
    NSNumber* idNumber =  [dict objectForKey:@"weibo_id"];

//    NSNumber* stat = [cellItem.detailInfo objectForKey:@"favorited"];
    
    //NSString* cl = [stat  className];
    NSUInteger index = [buttons indexOfObject:button];

//    NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
//    Get button info if needed;
    
    switch (index) {
        case MaReplayButton:
            //[engine repostWithWeiboID:idNumber message:@"RE:"];
            [self repostMessageWithWeiboID:idNumber];
            break;
            
        case MaRePostButton:
            [self commentMessageWithWeiboID:idNumber];
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
    
//    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
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

//    MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
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

#pragma mark - CommentMessage 
-(void)commentMessageWithWeiboID:(NSNumber*)idNumber
{
    MaPostController* postViewController = [[MaPostController alloc] init];
    UINavigationController *postNavController = [[UINavigationController alloc] initWithRootViewController:postViewController];
    postViewController.weiboID = idNumber;
    postViewController.msgType = MaSendMessageType_Comment;
    
    [self presentModalViewController:postNavController animated:YES];

}


@end
