//
//  DTViewController.m
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import "DTViewController.h"
#import "UIImageView+DTPhotoBrowser.h"
#import "DTPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SAMPLE_IMAGE_1			[UIImage imageNamed:@"sample1.jpg"]
#define SAMPLE_IMAGE_2			[UIImage imageNamed:@"sample2.jpg"]
#define SAMPLE_IMAGE_3			[UIImage imageNamed:@"sample3.jpg"]
#define SAMPLE_IMAGE_4			[UIImage imageNamed:@"sample4.jpg"]

@interface DTViewController ()

@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _samplePictures = @[
                        @"http://image.stardaily.vn/stardaily.vn/2014/08/15/22/20140815221905-dinh-du-lich-1-tuan--di-luon-16-nam-stardaily-f-642x290.jpg",
                        @"http://s29.postimg.org/efthwu3cn/ivivu_banner_right.jpg",
                        @"http://image.stardaily.vn/stardaily.vn/2014/08/15/22/20140815221622-dinh-du-lich-1-tuan--di-luon-16-nam-stardaily-1.jpg",
                        @"http://image.stardaily.vn/stardaily.vn/2014/08/15/22/20140815222453-dinh-du-lich-1-tuan--di-luon-16-nam-stardaily-3.jpg",
                        @"http://image.stardaily.vn/stardaily.vn/2014/08/15/22/20140815222453-dinh-du-lich-1-tuan--di-luon-16-nam-stardaily-4.jpeg"];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _samplePictures.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SampleControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	[self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableView Delegate methods


#pragma mark - Private methods

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
	if (!imageView) {
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 35, 90, 90)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.tag = 1;
		
		[cell.contentView addSubview:imageView];
	}
    [imageView setImageWithURL:[NSURL URLWithString:_samplePictures[indexPath.row]] placeholderImage:nil];
    [imageView setupDTPhotoBrowserWithIndex:indexPath.row withPhotoUrls:_samplePictures];
	
	UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:2];
	if (!titleLabel) {
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 15)];
		titleLabel.font = [UIFont boldSystemFontOfSize:17];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		
		[cell.contentView addSubview:titleLabel];
	}
}

@end
