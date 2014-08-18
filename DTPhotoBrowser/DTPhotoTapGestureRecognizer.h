//
//  DTPhotoTapGestureRecognizer.h
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPhotoTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSArray *listPhotos;
@property (nonatomic, assign) int initialIndex;

@end
