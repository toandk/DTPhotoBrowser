//
//  DTPhotoBrowser.h
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTHorizontalTableView.h"

typedef enum {
    BarAnimationStateHidden = 0,
    BarAnimationStateShowing,
    BarAnimationStateAnimating,
} BarAnimationState;

@class DTPhotoBrowser;

@protocol DTPhotoBrowserDelegate <NSObject>

@optional
-(UIImageView*)senderImageViewAtIndex:(int)index willScrollToImage:(BOOL)willScroll;
-(void)browser:(DTPhotoBrowser*)browser didScrollToIndex:(int)index;

@end

@interface DTPhotoBrowser : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    __weak IBOutlet DTHorizontalTableView *_tableView;
    __weak IBOutlet UIView *bottomBar;
    __weak IBOutlet UILabel *pageLabel;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIImageView *backgroundImg, *blackMaskImg;
    
    NSArray *photoUrls;
    UIImageView *senderImg;
    BarAnimationState barState;
}

@property int currentIndex;
@property (nonatomic, assign) id<DTPhotoBrowserDelegate> delegate;

+ (DTPhotoBrowser*)showWithPhotoUrls:(NSArray*)urls withInitialIndex:(int)index withSender:(UIImageView*)sender;

@end
