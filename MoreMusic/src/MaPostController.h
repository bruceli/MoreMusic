//
//  MaPostController.h
//  WeiboNote
//
//  Created by Accthun He on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"
#import "WBEngine.h"
#import "MaMoreMusicDefine.h"

#define IMAGE_ICON_INDEX 2

@interface MaPostController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    // PostController UI element.
    UIToolbar* _postToolbar;
    UILabel* _theLable;
    UIBarButtonItem* cameraButton;
    UIBarButtonItem* imageButton;
    UITextView* _textView;
    UINavigationBar* _navBar;
    UIImagePickerController *imagePickerController;
    NSInteger textCount;
    NSInteger textCountSEC;

    // PostController Status.
    BOOL isSendCancelled;
    BOOL isViewImage;
    
    // PostController Message Data
    UIImage* capturedImage;
    WBEngine* engine;
    NSNumber* weiboID;      
    MaSendMessageType msgType;

}
//@property (nonatomic, copy) NSString *postToolbar;
@property (nonatomic, copy) NSNumber *weiboID;
@property (nonatomic) MaSendMessageType msgType;


@end
