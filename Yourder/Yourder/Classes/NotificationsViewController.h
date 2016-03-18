//
//  NotificationsViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 23/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "NotificationTableViewCell.h"

@interface NotificationsViewController : UIViewController <RapidzzUserManagerDelegate, UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblNotifications;
@property (strong, nonatomic) RapidzzUserManager *manager;
@property (strong, nonatomic) NSMutableArray *arrNotifications;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *btn_split;
@property (weak, nonatomic) IBOutlet UIButton *btn_decline;


@end
