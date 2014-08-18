//
//  DTHorizontalTableView.m
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/18/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import "DTHorizontalTableView.h"

@implementation DTHorizontalTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupTableView {
    CGRect frame = self.frame;
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.frame = frame;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView* child in self.visibleCells) {
        
        CGRect frame1 = child.frame;
        if ([child isKindOfClass:[UITableViewCell class]]) {
            frame1.size.width = self.frame.size.height;
            child.frame = frame1;
        }
    }
}

@end
