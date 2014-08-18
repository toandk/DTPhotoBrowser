//
//  UIImageView+DTPhotoBrowser.m
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import "UIImageView+DTPhotoBrowser.h"
#import "DTPhotoBrowser.h"
#import "DTPhotoTapGestureRecognizer.h"

@implementation UIImageView (DTPhotoBrowser)

-(void)setupDTPhotoBrowserWithIndex:(int)index withPhotoUrls:(NSArray*)photoUrls {
    self.userInteractionEnabled = YES;
    DTPhotoTapGestureRecognizer *gesture = [[DTPhotoTapGestureRecognizer alloc] initWithTarget:self action:@selector(showDTPhotoBrowser:)];
    gesture.cancelsTouchesInView = NO;
    gesture.listPhotos = photoUrls;
    gesture.initialIndex = index;
    [self addGestureRecognizer:gesture];
}

-(void)showDTPhotoBrowser:(DTPhotoTapGestureRecognizer*)gesture {
    [DTPhotoBrowser showWithPhotoUrls:gesture.listPhotos withInitialIndex:gesture.initialIndex withSender:self];
}

@end
