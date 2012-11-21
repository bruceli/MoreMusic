//
//  MaMessageListController.m
//  WeiboNote
//
//  Created by Zihan He on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreMusicAppDelegate.h"
#import "MaMessageListController.h"
#import "MaMoreMusicDefine.h"

@interface MaMessageListController (Private)
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction;
- (void) setupGestureRecognizers;
- (void) swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction;

- (void)removeCachedOAuthDataForUsername:(NSString* ) username;
- (void) setupSideSwipeView;
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage;

@end

@implementation MaMessageListController
@synthesize tabBarButton;
@synthesize sideSwipeView, sideSwipeCell, sideSwipeDirection, animatingSideSwipe;
@synthesize favArray = _favArray;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    animatingSideSwipe = NO;
    swipeOutContentView = nil;
    
    [self setupGestureRecognizers];
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    if (!_favArray) {
        _favArray = [[NSMutableArray alloc] init];
    }

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidUnload
{
    _messages = nil;
}

- (void)dealloc
{
    [_messages release];
    [buttons release];
    [buttonData release];
    
    [super dealloc];
}


- (void)openAuthenticateView
{
    
}
- (void)loadMessagesAtPage:(int)numPage count:(int)count
{
    
    
}


- (void) setupSideSwipeView
{
    // Add the background pattern
    self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage *shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView* shadowImageView = [[[UIImageView alloc] initWithFrame:sideSwipeView.frame] autorelease];
    shadowImageView.alpha = 0.6;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    // Iterate through the button data and create a button for each entry
    CGFloat leftEdge = BUTTON_LEFT_MARGIN;
    for (NSDictionary* buttonInfo in buttonData)
    {
        // Create the button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Make sure the button ends up in the right place when the cell is resized
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        // Get the button image
        UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
        
        // Set the button's frame
        button.frame = CGRectMake(leftEdge, sideSwipeView.center.y - buttonImage.size.height/2.0, buttonImage.size.width, buttonImage.size.height);
        
        // Add the image as the button's background image
        // [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        UIImage* grayImage = [self imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
        [button setImage:grayImage forState:UIControlStateNormal];
        
        // Add a touch up inside action
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Keep track of the buttons so we know the proper text to display in the touch up inside action
        [buttons addObject:button];
        
        // Add the button to the side swipe view
        [self.sideSwipeView addSubview:button];
        
        // Move the left edge in prepartion for the next button
        leftEdge = leftEdge + buttonImage.size.width + BUTTON_SPACING;
    }
}

- (BOOL) gestureRecognizersSupported
{
    if (!USE_GESTURE_RECOGNIZERS) return NO;
    
    // Apple's docs: Although this class was publicly available starting with iOS 3.2, it was in development a short period prior to that
    // check if it responds to the selector locationInView:. This method was not added to the class until iOS 3.2.
    return [[[[UISwipeGestureRecognizer alloc] init] autorelease] respondsToSelector:@selector(locationInView:)];
}

- (void) setupGestureRecognizers
{
    // Do nothing under 3.x
    if (![self gestureRecognizersSupported]) return;
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)] autorelease];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_tableView addGestureRecognizer:rightSwipeGestureRecognizer];
    
    // Setup a left swipe gesture recognizer
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)] autorelease];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_tableView addGestureRecognizer:leftSwipeGestureRecognizer];
    
//    [_tableView addTarget:self action:(SEL)@"touchsBegan" forControlEvents:UIControlEventTouchUpInside];

}

// Called when a left swipe occurred
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionLeft];
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionRight];
}

// Handle a left or right swipe
- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{

    if (recognizer && recognizer.state == UIGestureRecognizerStateEnded)
    {
        // Get the table view cell where the swipe occured
        CGPoint location = [recognizer locationInView:_tableView];
        NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:location];
        UITableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
        
        // If we are already showing the swipe view, remove it
//        if (cell.frame.origin.x != 0)
        
        if(swipeOutContentView)
        {
            if(cell == sideSwipeCell){
                [self removeSideSwipeView:YES];
                return;
            }
            else{
                [self removeSideSwipeView:NO];
                [NSThread sleepForTimeInterval:0.1];
            }
        }        
        
        // Make sure we are starting out with the side swipe view and cell in the proper location
        [self removeSideSwipeView:NO];
        
        // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
        // then start animating in the the side swipe view
        if (cell!= sideSwipeCell && !animatingSideSwipe)
        {
            _lastSwipeStartPoint = [recognizer locationInView:cell];
            [self addSwipeViewTo:cell direction:direction];
        }
    }
}

#pragma mark Side Swiping under iPhone 3.x
- (void)tableView:(UITableView *)theTableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are using gestures, then don't do anything
    if ([self gestureRecognizersSupported]) return;
    
    // Get the table view cell where the swipe occured
    UITableViewCell* cell = [theTableView cellForRowAtIndexPath:indexPath];
    
    // Make sure we are starting out with the side swipe view and cell in the proper location
    [self removeSideSwipeView:NO];
    
    // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
    // then start animating in the the side swipe view. We don't have access to the direction, so we always assume right
    if (cell!= sideSwipeCell && !animatingSideSwipe)
        [self addSwipeViewTo:cell direction:UISwipeGestureRecognizerDirectionRight];
}

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are using gestures, then don't allow editing
    if ([self gestureRecognizersSupported])
        return NO;
    else
        return YES;
}

#pragma mark Adding the side swipe view
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction
{
    // Change the frame of the side swipe view to match the cell
    // sideSwipeView.frame = cell.frame;
    
    // Add the side swipe view to the table above the cell
    [_tableView insertSubview:sideSwipeView  aboveSubview:cell];
    
    // Remember which cell the side swipe view is displayed on and the swipe direction
    self.sideSwipeCell = cell;
    sideSwipeDirection = direction;
    // UISwipeGestureRecognizerDirectionRight)   // from right 
    // UISwipeGestureRecognizerDirectionLeft)   // from left
    CGRect cellFrame = cell.frame;
    
//    NSLog(@"Dy Swipe Y Location %f",cellFrame.origin.y +_lastSwipeStartPoint.y);
//    NSLog(@"St Swipe Y Location %f",cellFrame.origin.y + cellFrame.size.height / 2 - SWIPE_BAR_HEIGHT / 2);
//    NSLog(@"\n");

    CGFloat swipeY = cellFrame.origin.y +_lastSwipeStartPoint.y;
    if ((swipeY+SWIPE_BAR_HEIGHT)>cellFrame.origin.y+cellFrame.size.height) {
        swipeY = cellFrame.origin.y+cellFrame.size.height - SWIPE_BAR_HEIGHT;
    }
    
    CGRect sideSwipeFrame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? -cellFrame.size.width : cellFrame.size.width,swipeY, cellFrame.size.width, SWIPE_BAR_HEIGHT);
        
    CGRect fabsRect = sideSwipeFrame;
    fabsRect.origin.x = 0;
    fabsRect.origin.y = sideSwipeFrame.origin.y - cellFrame.origin.y; // convert to cell view coordinate
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cell,[NSValue valueWithCGRect:fabsRect],Nil] forKeys:[NSArray arrayWithObjects:@"view",@"rect",Nil]];
    [NSThread detachNewThreadSelector:@selector(imageWithView:) toTarget:self withObject:dict];

    
    [sideSwipeView setFrame:sideSwipeFrame];
    
    animatingSideSwipe = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopAddingSwipeView:finished:context:)];
    CGRect targtFrame = CGRectMake(0, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        [sideSwipeView setFrame:targtFrame];
    
    [UIView commitAnimations];
}

// Note that the animation is done
- (void)animationDidStopAddingSwipeView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
}

#pragma mark Removing the side swipe view
// UITableViewDelegate
// When a row is selected, animate the removal of the side swipe view
- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeSideSwipeView:YES];
    return indexPath;
}

// UIScrollViewDelegate
// When the table is scrolled, animate the removal of the side swipe view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeSideSwipeView:YES];
}

// When the table is scrolled to the top, remove the side swipe view
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self removeSideSwipeView:NO];
    return YES;
}

// Remove the side swipe view.
// If animated is YES, then the removal is animated using a bounce effect
- (void) removeSideSwipeView:(BOOL)animated
{
    // Make sure we have a cell where the side swipe view appears and that we aren't in the middle of animating
    if (!sideSwipeCell || animatingSideSwipe) return;
    
    [_tableView insertSubview:swipeOutContentView  aboveSubview:sideSwipeView];
    if (animated)
    {
        CGRect swipeFrame = sideSwipeView.frame;
        CGRect contentFrame = CGRectMake(sideSwipeDirection == UISwipeGestureRecognizerDirectionRight ? swipeFrame.size.width : -swipeFrame.size.width,swipeFrame.origin.y, swipeFrame.size.width, SWIPE_BAR_HEIGHT);
        [swipeOutContentView setFrame:contentFrame];

        // The first step in a bounce animation is to move the side swipe view a bit offscreen
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
        {
            swipeOutContentView.frame = CGRectMake(BOUNCE_PIXELS, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        }
        else
        {
            swipeOutContentView.frame = CGRectMake(-BOUNCE_PIXELS, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        }
        animatingSideSwipe = YES;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStopOne:finished:context:)];
        [UIView commitAnimations];
    }
    else
    {
        [sideSwipeView removeFromSuperview];
        sideSwipeCell.frame = CGRectMake(0,sideSwipeCell.frame.origin.y,sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        self.sideSwipeCell = nil;
        [swipeOutContentView removeFromSuperview];
        swipeOutContentView = nil;

    }
}

#pragma mark Bounce animation when removing the side swipe view
// The next step in a bounce animation is to move the side swipe view a bit on screen
- (void)animationDidStopOne:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        swipeOutContentView.frame = CGRectMake(BOUNCE_PIXELS*2, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    }
    else
    {
        swipeOutContentView.frame = CGRectMake(-BOUNCE_PIXELS*2, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopTwo:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// The final step in a bounce animation is to move the side swipe completely offscreen
- (void)animationDidStopTwo:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        swipeOutContentView.frame = CGRectMake(0, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    }
    else
    {
        swipeOutContentView.frame = CGRectMake(0, sideSwipeView.frame.origin.y, sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopThree:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// When the bounce animation is completed, remove the side swipe view and reset some state
- (void)animationDidStopThree:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
    self.sideSwipeCell = nil;
    
    [sideSwipeView removeFromSuperview];
    [swipeOutContentView removeFromSuperview];
    swipeOutContentView = nil;

}

-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    // Fill with color
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

- (void) touchUpInsideAction:(UIButton*)button
{
    [self removeSideSwipeView:YES];
}

- (void) imageWithView:(NSDictionary *)dict
{
    UIView* view = [dict objectForKey:@"view"];
    CGRect rect = [[dict objectForKey:@"rect"] CGRectValue];
//    rect.origin.x = fabs(rect.origin.x);
    UIImage* swipeOutImage;
    if (view) {        
        UIGraphicsBeginImageContext(view.bounds.size);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

// Test  
        /*      
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"fullCell.jpg"];
        [fileManager createFileAtPath:fullPath contents:data attributes:nil];
        */
// end of the test code
        
        if (image) {
            CGImageRef drawImage = CGImageCreateWithImageInRect(image.CGImage, rect);
            swipeOutImage = [UIImage imageWithCGImage:drawImage];
            CGImageRelease(drawImage);
        }
    }
    // Test     
    /*
    NSData *data = UIImageJPEGRepresentation(swipeOutImage, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"subcell.jpg"];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
     */
    // end of the test code

     swipeOutContentView = (UIImageView*)[[UIImageView alloc]initWithImage:swipeOutImage];
}




@end