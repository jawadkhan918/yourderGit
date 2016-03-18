//
//  WaiterDetailViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 16/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"
#import "RapidzzUserManager.h"

@interface WaiterDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,RapidzzUserManagerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tblTables;
@property (weak, nonatomic) IBOutlet UILabel *lblWaiterName;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSMutableArray *arrWaiterTabels;
@property (strong, nonatomic) RapidzzUserManager *manager;


@end
