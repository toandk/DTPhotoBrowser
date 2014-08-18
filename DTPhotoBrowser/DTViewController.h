//
//  DTViewController.h
//  DTPhotoBrowser
//
//  Created by ToanDK on 8/16/14.
//  Copyright (c) 2014 ToanDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_samplePictures;
    __weak IBOutlet UITableView *_tableView;
}

@end
