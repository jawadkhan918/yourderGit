//
//  SplitNotificationPopupVC.h
//  Yourder
//
//  Created by Rapidzz on 18/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RapidzzUserManager.h"

@interface SplitNotificationPopupVC : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *imgLogo ;
@property (nonatomic, strong) IBOutlet UILabel *lblUsername;
@property (nonatomic, strong) IBOutlet UILabel *lblDishName;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;
@property (nonatomic, strong) IBOutlet UIButton *btnSplit;

@property (strong, nonatomic) RapidzzUserManager *manager;




@end
