//
//  TableListViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 16/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResturantOrderTableViewCell.h"
#import "RapidzzUserManager.h"

@interface TableListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,RapidzzUserManagerDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tblTables;
@property (strong , nonatomic) RapidzzUserManager *manager;
@property (strong , nonatomic) NSMutableArray *arrTablesList;


@end
