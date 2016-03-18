//
//  userSettingViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 01/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface userSettingViewController : UIViewController


@property (weak ,nonatomic) IBOutlet IQDropDownTextField *txtSearchRadius;
@property (strong ,nonatomic) IBOutlet UISwitch *swNotifications;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;


@end
