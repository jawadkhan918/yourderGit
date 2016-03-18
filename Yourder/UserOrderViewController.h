//
//  UserOrderViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 11/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RapidzzUserManager.h"
#import "UserOrderViewController.h"
#import "SWRevealViewController.h"

@interface UserOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RapidzzUserManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *lblOrdered;
@property (weak, nonatomic) IBOutlet UILabel *lblServed;
@property (weak, nonatomic) IBOutlet UIButton *slider_btn;
@property (strong , nonatomic) NSMutableArray *arrUserDishes;
@property (strong , nonatomic) NSMutableArray *arrServedOrder;

@property (strong ,nonatomic) RapidzzUserManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *Table;

@property (strong, nonatomic) NSDictionary *dictSelectedUserInfo;




@end
