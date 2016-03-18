//
//  YourorderViewController.h
//  Yourder
//
//  Created by Rapidzz on 12/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourorderTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YourorderTableViewCell.h"

@interface YourorderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RapidzzUserManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *dictSelectedRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *lblRestName;
@property (weak, nonatomic) IBOutlet UILabel *lblRestAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgRestLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserthumb;
@property (strong, nonatomic) RapidzzUserManager *manager;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblTableNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTablePersons;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UITableView *tblOrder;

@property (weak, nonatomic) IBOutlet UIButton *btnRightSliderCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;



@property (readwrite) float totalAmount;






-(void) saveOrder;




@end
