//
//  MaPostController.m
//  WeiboNote
//
//  Created by Accthun He on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaPostController.h"
#import "MoreMusicAppDelegate.h"
#import "MaAuthMgr.h"
#import "Three20Core/NSStringAdditions.h"
#import "RDActionSheet.h"
#import "MaImageViewController.h"
#import "UIImage+Resize.h"



@interface MaPostController() 
-(void)removeCapturedImage;
-(void)removeCameraButton;
-(void)viewCapturedImage;
-(void)updateSendButtonStatus;
-(void)setupPostCtrlStatus;
-(UIImage*)resizeImage:(UIImage*)inImage;
-(UIImage*)textToImage:(NSString*)text;
-(BOOL)isMaxLength:(NSString*)text;
@end

@implementation MaPostController

@synthesize weiboID,msgType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        isSendCancelled = YES;
        isViewImage = YES;
        capturedImage = nil;

        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        _postToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, screenBounds.size.width, 44)];
        // Init Navbar
        UIBarButtonItem* sndButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
        self.navigationItem.rightBarButtonItem = sndButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        cancelButton.title = @"Cancel";
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        // init textView
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 0)];
        [_textView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        self.view.backgroundColor = [UIColor grayColor];
        [_textView becomeFirstResponder];
        [self.view addSubview:_textView];
        //Disable scrollerIndicator
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = YES;

        _textView.delegate = self;
                
        // other init actions.
        
        UIImage* camIcon = [UIImage imageNamed:@"camera.png"];
        UIButton *camBaseButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        camBaseButton.frame = CGRectMake(0, 0, 30, 30); 
        [camBaseButton setImage:camIcon forState:UIControlStateNormal];
        [camBaseButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
         cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camBaseButton];

    
    //    cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addImage)];
     //   cameraButton.style=UIBarButtonItemStylePlain; 
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        // Location button
        UIImage* locIcon = [UIImage imageNamed:@"Location.png"];
        UIButton *baseButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        baseButton.frame = CGRectMake(0, 0, 30, 30); 
        [baseButton setImage:locIcon forState:UIControlStateNormal];
        [baseButton addTarget:self action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* locButton = [[UIBarButtonItem alloc] initWithCustomView:baseButton];
        
        // Mentions button
        UIImage* mentionIcon = [UIImage imageNamed:@"Mentions.png"];
        UIButton *mentionBaseButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        mentionBaseButton.frame = CGRectMake(0, 0, 30, 30); // position in the parent view and set the size of the button
        [mentionBaseButton setImage:mentionIcon forState:UIControlStateNormal];
        [mentionBaseButton addTarget:self action:@selector(mention) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* menButton = [[UIBarButtonItem alloc] initWithCustomView:mentionBaseButton];
        
        
        // Counting lable
        _theLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 120, 21.0f)];
        [_theLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [_theLable setBackgroundColor:[UIColor clearColor]];
        [_theLable setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
        [_theLable setText:@"140"];
        [_theLable setTextAlignment:UITextAlignmentRight];
        UIBarButtonItem* lableItem = [[UIBarButtonItem alloc] initWithCustomView:_theLable];
        
        
        NSArray *items = [[NSArray alloc] initWithObjects: locButton, menButton, cameraButton, flexibleSpace, lableItem, nil];
        [_postToolbar setItems:items];
        _postToolbar.barStyle = UIBarStyleBlackTranslucent;
        [self.view addSubview:_postToolbar];
        
        [_postToolbar sizeToFit];
        //Set the toolbar to fit the width of the app. 
    
        // get WeiboEngine
        MoreMusicAppDelegate* app = (MoreMusicAppDelegate *)[[UIApplication sharedApplication] delegate];
        MaAuthMgr* authMgr = app.authMgr;
        engine = authMgr.currentEngine;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set Navbar title
    [self setupPostCtrlStatus];
    

    [super viewWillAppear:animated];
}


-(void)setupPostCtrlStatus
{
    switch (msgType) {
        case MaSendMessageType_Post:
            self.navigationItem.title = @"Post Message";
            break;
            
        case MaSendMessageType_RePost:
            self.navigationItem.title = @"RePost Message";
            [self removeCameraButton];
            break;
            
        case MaSendMessageType_Comment:
            self.navigationItem.title = @"Comment Message";
            [self removeCameraButton];
            break;
            
        default:
            break;
    }

}

- (void)keyboardWillShow:(NSNotification *)notification 
{
    // Get Keyboard Top point
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = keyboardRect.size.height;
//    NSLog(@"keyboardHeight is %f", keyboardHeight); 

    CGFloat textViewHeight = self.view.bounds.size.height - keyboardHeight -_postToolbar.bounds.size.height;
//    NSLog(@"textViewHeight is %f ",textViewHeight);

    CGRect newScreenViewRect = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, textViewHeight);
    _textView.frame = newScreenViewRect;
    
    //CGFloat toolbarY = keyboardRect.origin.y - _postToolbar.bounds.size.height;
    CGFloat toolbarY = self.view.bounds.size.height - keyboardHeight -_postToolbar.bounds.size.height ;
    
    CGRect toolbarRect = CGRectMake(self.view.bounds.origin.x, toolbarY, _postToolbar.frame.size.width, _postToolbar.frame.size.height);
//    NSLog(@"Toolbar Button is %f",toolbarY +  _postToolbar.bounds.size.height); 
//    NSLog(@"Keyboard Top point is %f", keyboardRect.origin.y ); 
//    NSLog(@"\n");
    
    _postToolbar.frame = toolbarRect;
}

- (void)scrollViewDidScroll:(id)scrollView
{
    // disable Horizontal Scrolling
    CGPoint origin = [scrollView contentOffset]; 
    [scrollView setContentOffset:CGPointMake(0, origin.y)];
}

-(void)updateTextCounter
{
    // Enable send button
    // Change character counts
    // Change CamaraButton
    
    if ([self isMaxLength:_textView.text]) 
        _theLable.text = @"Long Message";  
    else
        _theLable.text = [NSString stringWithFormat:@"%d", MAX_TEXT_LENGTH - textCount];
    
    [self updateSendButtonStatus];
    [self updateCaptureImageButtonStatus];

}

- (void)textViewDidChange:(UITextView *)textView
{    
    [self updateTextCounter];
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [self updateTextCounter];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{   
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        [self presentModalViewController:imagePickerController animated:YES];
    }
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.delegate = self;
        cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        cameraUI.allowsEditing = NO;
        [self presentModalViewController: cameraUI animated: YES];
        
    } 
}

- (void)addImage
{
    [_textView resignFirstResponder];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:@"Cancel" primaryButtonTitle:nil destroyButtonTitle:nil otherButtonTitles: @"Choose from Library", @"Take a Photo", nil];
        actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) 
        {
            
            switch (result) {
                case RDActionSheetButtonResultSelected:{
                    if(buttonIndex == 0){   // Select from Library
                        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                        
                    }
                    
                    if (buttonIndex == 1 ) {    // Take a Photo
                        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                    }
                    
                    NSLog(@"Pressed %i", buttonIndex);
                    break;
                }
                case RDActionSheetResultResultCancelled:{
                    //                    [_textView becomeFirstResponder];
                    
                }
                    NSLog(@"Sheet cancelled");
            }
        };
        
        [actionSheet showFrom: self.view];
        
    }
    else 
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)imageButtonAction
{
    [_textView resignFirstResponder];
    RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:@"Cancel" primaryButtonTitle:nil destroyButtonTitle:@"Delete Image" otherButtonTitles: @"View Image", nil];
    
    actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) 
    {
        switch (result) {
            case RDActionSheetButtonResultSelected:{
                if(buttonIndex == 0){   // Delete Image
                    isViewImage = YES;
                    [self removeCapturedImage];
                }
                
                if (buttonIndex == 1 ) {    // View Image
                    isViewImage = NO;
                    [self viewCapturedImage];
                }
                
                NSLog(@"Pressed %i", buttonIndex);
                break;
            }
                
            case RDActionSheetResultResultCancelled:{
                if(isViewImage)
                    [_textView becomeFirstResponder];    
            }
        }
    };
    
    [actionSheet showFrom: self.view];
}

- (void)addLocation
{
    
}

-(void)mention
{
    
}

- (void) sendMessage:(NSString*) text withImage:(UIImage*)image
{
    UIImage* outputImage = image;
    
    if (text.length == 0 && image) {
        text = @"Share image.";
    }
    
    //resize Image
    if (image) {
        if (capturedImage.size.width > OUTPUT_IMAGE_WIDE_MAX)
        {
            outputImage = [self resizeImage:image];
            [engine sendWeiBoWithText:text image:outputImage];
        }
        else {
            [engine sendWeiBoWithText:text image:image];
        }
    }
    else {
        [engine sendWeiBoWithText:text image:nil];
    }

}

-(void) rePostMessage:(NSString*) message
{
    [engine repostWithWeiboID:weiboID message:message];
}

- (void)post {
    
    if ([self isMaxLength:_textView.text ]) {   // Out of MAX_TEXT_LENGTH
        UIImage* img =  [self textToImage:_textView.text];
        [self sendMessage:@"Looog Message" withImage:img];
    }
    else {
        switch (msgType) {
            case MaSendMessageType_Post:
                [self sendMessage:_textView.text withImage:capturedImage];
                break;
                
            case MaSendMessageType_RePost:
                [self rePostMessage:_textView.text];
                break;
                
            case MaSendMessageType_Comment:
                break;
                
            default:
                break;
        }
    }
     
    [self destoryPostView];
}

- (void)destoryPostView{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
    if (TTIsStringWithAnyText(_textView.text)
        && !_textView.text.isWhitespaceAndNewlines)
    {
        [_textView resignFirstResponder];
        RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:@"Cancel" primaryButtonTitle:@"Save as Draft" destroyButtonTitle:@"Delete" otherButtonTitles: nil];
        actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) 
        {
            
            switch (result) {
                case RDActionSheetButtonResultSelected:
                    
                    if(buttonIndex == 0){   //Delete this weibo
                        [self destoryPostView];    
                        isSendCancelled = NO;
                    }
                    
                    if (buttonIndex == 1 ) {    // Save this weibo
                        [self destoryPostView];    
                        isSendCancelled = NO;
                    }
                    
                    NSLog(@"Pressed %i", buttonIndex);
                    break;
                case RDActionSheetResultResultCancelled:
                    if (isSendCancelled) {
                        [_textView becomeFirstResponder];
                    }
                    NSLog(@"Sheet cancelled");
            }
        };
        
        [actionSheet showFrom: self.view];
    }
    else {
        [self destoryPostView];    

    }
}


-(void)updateImageButton
{
    UIButton* imgButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    imgButton.frame = CGRectMake(0, 0, 30, 30); 
    [imgButton setImage:capturedImage forState:UIControlStateNormal];
    [imgButton addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    imageButton = [[UIBarButtonItem alloc] initWithCustomView:imgButton];
    
}

-(void)updateSendButtonStatus
{
    if (_textView.text.length > 0 || capturedImage) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)updateCaptureImageButtonStatus
{
    if (textCount > MAX_TEXT_LENGTH ) {
        [cameraButton setEnabled:NO];
        [imageButton setEnabled:NO];
    }
    else{
        [cameraButton setEnabled:YES];
        [imageButton setEnabled:YES];
    }
}

-(void)updateToolbarImageIcon
{
    [self updateImageButton];  
    
    NSMutableArray* newItems = [NSMutableArray arrayWithArray: _postToolbar.items];
    NSInteger index = [newItems indexOfObject:cameraButton];
    
    [newItems replaceObjectAtIndex:index withObject:imageButton];
    
    [_postToolbar setItems:newItems animated:YES];
}

-(void)removeCapturedImage
{
//    [self updateImageButton];  
    
    NSMutableArray* newItems = [NSMutableArray arrayWithArray: _postToolbar.items];
    [newItems replaceObjectAtIndex:IMAGE_ICON_INDEX withObject:cameraButton];
    [_postToolbar setItems:newItems animated:YES];
    
    capturedImage = Nil;
    
    [self updateSendButtonStatus];
}

-(void)removeCameraButton
{
    NSMutableArray* newItems = [NSMutableArray arrayWithArray: _postToolbar.items];
    [newItems removeObject:cameraButton];
    [_postToolbar setItems:newItems animated:YES];
}

-(void)viewCapturedImage
{    
    MaImageViewController* viewImageController = [[MaImageViewController alloc] init];
    UINavigationController *viewImageNavController = [[UINavigationController alloc] initWithRootViewController:viewImageController];
    viewImageController.theImage = capturedImage;
    
    [self presentModalViewController:viewImageNavController animated:YES];
}


-(UIImage*)resizeImage:(UIImage*)inImage
{
    UIImage* resizedImage;
    CGFloat ratio = inImage.size.height / inImage.size.width;
    CGSize newImageSize;
    newImageSize.width = OUTPUT_IMAGE_WIDE_MAX;
    newImageSize.height = OUTPUT_IMAGE_WIDE_MAX * ratio;

  //  inImage = [inImage resizedImage:newImageSize ];
    resizedImage = [inImage resizedImage:newImageSize interpolationQuality:kCGInterpolationMedium];

    return resizedImage;
}

-(UIImage*)textToImage:(NSString*)text
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0,420,320)];
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 420, 320)];
    
    [view addSubview:lable];
    lable.textAlignment = UITextAlignmentLeft;
    lable.lineBreakMode = UILineBreakModeCharacterWrap;
    lable.numberOfLines = 0;

    
    lable.text = text;
    [lable sizeToFit];
    CGRect frame = lable.frame;
    frame.size.height = lable.frame.size.height+40;
    frame.size.width = lable.frame.size.width+40;
    [view setFrame:frame]; 
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"text.jpg"];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    */
    
    return image;

}

#pragma mark -
#pragma mark ImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    capturedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
    [self updateToolbarImageIcon];
    [self updateSendButtonStatus];
    [_textView becomeFirstResponder];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissModalViewControllerAnimated:YES];
    [_textView becomeFirstResponder];
}


-(BOOL)isMaxLength:(NSString*)text;
{
    int l=0,a=0,b=0;
    unichar c;
    for (int i=0; i<[text length]; i++)
    {
        c=[text characterAtIndex:i];
            if(isblank(c)){
                b++;
            }else if(isascii(c)){
                a++;
            }else{
                l++;
            }
    }
    if(a==0 && l==0) 
        textCount = 0;
    else 
        textCount = l+(int)ceilf((float)(a+b)/2.0);

    NSLog(@"Count Methord C, %d",textCount);
         
    if (textCount > MAX_TEXT_LENGTH)
        return YES;
    else
        return NO;
}


@end
