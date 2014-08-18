//
//  DTPhotoCell.h
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPhotoCell : UITableViewCell<UIScrollViewDelegate> {
    __weak IBOutlet UIScrollView *_scrollView;
    NSDictionary *imageInfo;
}
@property (nonatomic, weak) IBOutlet UIImageView *photoImg;

- (void)configCell:(NSString*)imgUrl;
- (void) configCellWithImagePath:(NSString*) imagePath;

- (void)setImageInfo:(NSDictionary*)info;

@end
