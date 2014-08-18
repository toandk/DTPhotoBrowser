//
//  DTPhotoCell.m
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import "DTPhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DTPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float) height {
    return 320;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.delegate = self;
    
    self.transform = CGAffineTransformMakeRotation(M_PI/2);
}

-(void)setImageInfo:(NSDictionary*)info {
    imageInfo = info;
}

-(void)configCell:(NSString*)imgUrl {
    NSLog(@"scrollView: %@", _scrollView);
    imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_photoImg setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil success:^(UIImage *image, BOOL cached) {
    } failure:^(NSError *error) {
    }];
}

- (void) configCellWithImagePath:(NSString*) imagePath {
    [_photoImg setImage:[UIImage imageWithContentsOfFile:imagePath]];
}


@end
