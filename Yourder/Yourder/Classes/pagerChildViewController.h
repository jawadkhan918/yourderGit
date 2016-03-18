//
//  pagerChildViewController.h
//  Yourder
//
//  Created by Rapidzz on 07/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CustomIOSAlertView.h"
#import "YourderPopupView.h"
#import "RestaurantMenuViewController.h"
#import "ServiceRequestViewController.h"


@interface pagerChildViewController : UIViewController <RapidzzUserManagerDelegate, UITableViewDelegate, UITableViewDataSource, CustomIOSAlertViewDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (strong, nonatomic) RapidzzUserManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tblDishes;
@property (strong, nonatomic) NSMutableArray *arrMenuItems;
@property (strong, nonatomic) NSMutableArray *arrOrder;





@property int catId;

//POP UP
@property (strong, nonatomic) YourderPopupView *objYourderView;
@property (strong, nonatomic) ServiceRequestViewController *objServiceView;
@property (nonatomic,strong) CustomIOSAlertView *alertView;



@end
