//
//  HistoryViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 11/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RapidzzUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblOrder;
@property (strong, nonatomic) RapidzzUserManager *manager;
@property (strong, nonatomic) NSMutableArray *arrOrderHistory;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;

@property (strong, nonatomic) NSIndexPath *expandedIndexPath;

@end
