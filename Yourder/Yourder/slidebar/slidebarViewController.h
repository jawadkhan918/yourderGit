//
//  slidebarViewController.h
//  iSend2U
//
//  Created by Ghafar Tanveer on 20/11/2015.
//  Copyright (c) 2015 Ghafar Tanveer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "menuSliderTableViewCell.h"


@interface slidebarViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgUser_Pic;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;

@property (weak, nonatomic) IBOutlet UITableView *tblMenu;

@end
