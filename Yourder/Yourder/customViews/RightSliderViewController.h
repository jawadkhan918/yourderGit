//
//  RightSliderViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 08/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourorderTableViewCell.h"
#import "RapidzzUserManager.h"
#import "SplitDetailPopVC.h"

@interface RightSliderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,RapidzzUserManagerDelegate, CustomIOSAlertViewDelegate>





@property (strong,nonatomic) RapidzzUserManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblTableNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTablePersons;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UITableView *tblOrder;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

//POP UP
@property (strong, nonatomic) SplitDetailPopVC *objSplitDetailPopUp;
@property (nonatomic,strong) CustomIOSAlertView *alertView;



-(IBAction)btnCancel:(id)sender;



@end
