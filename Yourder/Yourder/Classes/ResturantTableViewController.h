//
//  ResturantTableViewController.h
//  Yourder
//
//  Created by Kamran Butt on 1/28/16.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResturantTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RapidzzUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *Table;

@property (strong, nonatomic) RapidzzUserManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;

@end
