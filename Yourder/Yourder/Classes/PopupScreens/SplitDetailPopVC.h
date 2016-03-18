//
//  SplitDetailPopVC.h
//  Yourder
//
//  Created by Arslan Ilyas on 26/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitDetailPopupCell.h"
#import "MBProgressHUD.h"

@interface SplitDetailPopVC : UIViewController <RapidzzUserManagerDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) RapidzzUserManager *manager;
@property (strong, nonatomic) NSMutableArray *arrUsers;

@property (strong, nonatomic) NSDictionary *dictDishDetail;

@property (weak, nonatomic) IBOutlet UITableView *tblUsers;
@property (weak, nonatomic) IBOutlet UILabel *lblDishName;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;





-(IBAction)btnCancel:(id)sender;

@end

