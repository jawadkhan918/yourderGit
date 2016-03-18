//
//  OrdersViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 17/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RapidzzUserManagerDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tblOrders;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;
@property (strong, nonatomic) RapidzzUserManager *manager;

@end
