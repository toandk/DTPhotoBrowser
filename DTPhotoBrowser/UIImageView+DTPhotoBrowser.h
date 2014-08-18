//
//  UIImageView+DTPhotoBrowser.h
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTPhotoBrowser.h"

@interface UIImageView (DTPhotoBrowser)

-(void)setupDTPhotoBrowserWithIndex:(int)index withPhotoUrls:(NSArray*)photoUrls withDelegate:(id<DTPhotoBrowserDelegate>)delegate;

@end
