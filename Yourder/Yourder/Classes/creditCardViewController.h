//
//  creditCardViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 26/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cardPopupVC.h"
#import "RapidzzUserManager.h"
#import "CustomIOSAlertView.h"

@interface creditCardViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate,RapidzzUserManagerDelegate,UIAlertViewDelegate>


@property (weak,nonatomic) IBOutlet UITableView *tblCards;
@property (strong,nonatomic) RapidzzUserManager *manager;
@property (strong ,nonatomic) cardPopupVC *cardPopUp;
@property (nonatomic,strong) CustomIOSAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;


@end
