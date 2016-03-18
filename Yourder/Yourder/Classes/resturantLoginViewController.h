//
//  resturantLoginViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 25/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface resturantLoginViewController : UIViewController<UITextViewDelegate, RapidzzUserManagerDelegate>

@property(weak,nonatomic) IBOutlet UITextField *txtUserName;
@property(weak,nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) RapidzzUserManager *manager;



@end
