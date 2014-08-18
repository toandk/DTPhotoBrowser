//
//  DTPhotoBrowser.m
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import "DTPhotoBrowser.h"
#import "DTPhotoCell.h"

#define SHOW_BROWSER_ANIMATION_TIME     0.5
#define SHOW_TOOL_BAR_ANIMATION_TIME    0.3
#define LIMIT_PAN_GESTURE_OFFSET        50

@interface DTPhotoBrowser () {
    int initialIndex;
    BOOL _isdraggingPhoto, _statusBarOriginallyHidden;
    BOOL firstInit;
    CGRect originalFrame;
}

@end

@implementation DTPhotoBrowser

+ (DTPhotoBrowser*)showWithPhotoUrls:(NSArray*)urls withInitialIndex:(int)index withSender:(UIImageView*)sender {
    DTPhotoBrowser *browser = [[DTPhotoBrowser alloc] initWithPhotoUrls:urls withInitialIndex:index withSender:sender];
    [browser show];
    return browser;
}

- (id)initWithPhotoUrls:(NSArray*)urls withInitialIndex:(int)index withSender:(UIImageView*)sender
{
    self = [super initWithNibName:@"DTPhotoBrowser" bundle:nil];
    if (self) {
        senderImg = sender;
        photoUrls = urls;
        initialIndex = index;
        firstInit = YES;
    }
    return self;
}

#pragma mark Status bar
- (BOOL)prefersStatusBarHidden {
    
    if(_isdraggingPhoto) {
        if(_statusBarOriginallyHidden) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return (bottomBar.alpha == 0);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _statusBarOriginallyHidden = [UIApplication sharedApplication].statusBarHidden;
    if (firstInit) {
        [self setupTableView];
        [self addTableTapGesture];
        [self hideToolBar:NO];
        
        [self setupBackgroundWithImage:senderImg];
        [self presentAnimation];
        
        firstInit = NO;
        originalFrame = self.view.frame;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotateOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didRotateOrientation:(NSNotification*)notification {
    [self reloadTableView];
}

-(void)reloadTableView {
    [_tableView setupTableView];
    
    int currentIndex = [self getCurrentIndex];
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, currentIndex*_tableView.frame.size.width)];
}

#pragma mark Setup view

-(void)setupTableView {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [_tableView setupTableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    NSString *className = NSStringFromClass([DTPhotoCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:className];
    
    [_tableView reloadData];
    if (initialIndex > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:initialIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if ([self respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self scrollViewDidEndDecelerating:_tableView];
}


-(void)setupBackgroundWithImage:(UIImageView*)imgView {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    imgView.hidden = YES;
    UIImage *screenShot = [[self class] captureScreenOfView:rootViewController.view];
    imgView.hidden = NO;
    backgroundImg.image = screenShot;
}

- (void) addTableTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:gesture];
}

-(void)didTapGesture:(UITapGestureRecognizer*)tapGesture {
    if (barState == BarAnimationStateHidden) {
        [self showToolBar:YES];
    }
    else if (barState == BarAnimationStateShowing) {
        [self hideToolBar:YES];
    }
}

-(void)panGestureRecognized:(UIPanGestureRecognizer*)gesture {
    static CGPoint firstCenter;
    CGPoint translatedPoint = [gesture translationInView:self.view];
    UIImageView *imageView = [self getCurrentCell].photoImg;
    // Gesture Began
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self hideToolBar:YES];
        firstCenter = imageView.center;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
            [self setNeedsStatusBarAppearanceUpdate];
    }
    translatedPoint = CGPointMake(firstCenter.x, firstCenter.y + translatedPoint.y);
    [imageView setCenter:translatedPoint];
    
    float newY = imageView.center.y - self.view.frame.size.height/2;
    float newAlpha = 1 - abs(newY)/self.view.frame.size.height; //abs(newY)/viewHeight * 1.8;
    
    blackMaskImg.alpha = newAlpha;
    
    // Gesture Ended
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        if(imageView.center.y > self.view.frame.size.height/2+LIMIT_PAN_GESTURE_OFFSET ||
           imageView.center.y < self.view.frame.size.height/2-LIMIT_PAN_GESTURE_OFFSET) // Automatic Dismiss View
        {
            [self doneAction:nil];
        }
        else { // Continue Showing View
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                [self setNeedsStatusBarAppearanceUpdate];
            
            CGFloat velocityY = (.35*[gesture velocityInView:self.view].y);
            
            CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [imageView setCenter:firstCenter];
            [UIView commitAnimations];
        }
    }
}

- (UIImage*) getCurrentImage {
    int currentIndex = [self getCurrentIndex];
    DTPhotoCell *cell = (DTPhotoCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    return cell.photoImg.image;
}

- (int) getCurrentIndex {
    int currentIndex = _tableView.contentOffset.y / _tableView.frame.size.width;
    return currentIndex;
}

- (DTPhotoCell*)getCurrentCell {
    int currentIndex = [self getCurrentIndex];
    DTPhotoCell *cell = (DTPhotoCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    return cell;
}

#pragma mark Show and Hide

-(void)presentAnimation {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    DTPhotoCell *currentCell = [self getCurrentCell];
    CGPoint pointInWindow = [senderImg convertPoint:senderImg.bounds.origin toView:rootViewController.view];
    CGRect frame = currentCell.photoImg.frame;
    currentCell.photoImg.frame = CGRectMake(pointInWindow.x, pointInWindow.y, senderImg.frame.size.width, senderImg.frame.size.height);
    
    [UIView animateWithDuration:SHOW_BROWSER_ANIMATION_TIME animations:^{
        blackMaskImg.alpha = 1.0;
        currentCell.photoImg.frame = frame;
    } completion:^(BOOL finished) {
        [self showToolBar:YES];
    }];
}

-(void)show {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController presentViewController:self animated:NO completion:^{
    }];
}

-(void)showToolBar:(BOOL)animated {
    float time = SHOW_TOOL_BAR_ANIMATION_TIME;
    if (!animated) time = 0;
    barState = BarAnimationStateAnimating;
    [UIView animateWithDuration:time animations:^{
        bottomBar.alpha = 1.0;
        doneButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        barState = BarAnimationStateShowing;
    }];
}

-(void)hideToolBar:(BOOL)animated {
    float time = SHOW_TOOL_BAR_ANIMATION_TIME;
    if (!animated) time = 0;
    barState = BarAnimationStateAnimating;
    [UIView animateWithDuration:time animations:^{
        bottomBar.alpha = 0.0;
        doneButton.alpha = 0;
    } completion:^(BOOL finished) {
        barState = BarAnimationStateHidden;
    }];
}

#pragma mark UITableView delegate
- (int) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return photoUrls.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([DTPhotoCell class]);
    DTPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DTPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell configCell:photoUrls[indexPath.row]];
//    cell.frame = originalFrame;
    NSLog(@"cell frame: %f %f %f %f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = _tableView.frame.size.width;
    return height;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageIndex = [self getCurrentIndex];
    pageLabel.text = [NSString stringWithFormat:@"%d/%d", pageIndex + 1, photoUrls.count];
    
    if (pageIndex != self.currentIndex) {
        self.currentIndex = pageIndex;
        if (self.delegate && [self.delegate respondsToSelector:@selector(browser:didScrollToIndex:)]) {
            [self.delegate browser:self didScrollToIndex:pageIndex];
            if ([self.delegate respondsToSelector:@selector(senderImageViewAtIndex:willScrollToImage:)]) {
                UIImageView *imgView = [self.delegate senderImageViewAtIndex:pageIndex willScrollToImage:NO];
                if (imgView) {
                    [self setupBackgroundWithImage:imgView];
                }
            }
        }
    }
}

#pragma mark Actions
-(IBAction)doneAction:(id)sender {
    [self hideToolBar:NO];
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIImageView *senderImageView = senderImg;
    if (self.delegate && [self.delegate respondsToSelector:@selector(senderImageViewAtIndex:willScrollToImage:)])
        senderImageView = [self.delegate senderImageViewAtIndex:[self getCurrentIndex] willScrollToImage:NO];
    CGPoint point = [senderImageView convertPoint:senderImageView.bounds.origin toView:rootViewController.view];
    CGRect senderRect = CGRectMake(point.x, point.y, senderImageView.frame.size.width, senderImageView.frame.size.height);
    [self setupBackgroundWithImage:senderImageView];
    
    DTPhotoCell *currentCell = [self getCurrentCell];
    [UIView animateWithDuration:0.5 animations:^{
        blackMaskImg.alpha = 0.0;
        currentCell.photoImg.frame = senderRect;
    } completion:^(BOOL finished) {
        senderImg = nil;
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }];
}

+ (UIImage *)captureScreenOfView:(UIView *)aview {
    UIGraphicsBeginImageContextWithOptions(aview.frame.size, YES, 0.0f);
    [aview.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
