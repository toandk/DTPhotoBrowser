//
//  DTPhotoTapGestureRecognizer.h
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTPhotoBrowser.h"

@interface DTPhotoTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSArray *listPhotos;
@property (nonatomic, assign) int initialIndex;
@property (nonatomic, weak) id<DTPhotoBrowserDelegate> browserDelegate;

@end
