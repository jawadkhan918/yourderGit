//
//  YourderPopupView.h
//  Yourder
//
//  Created by Rapidzz on 15/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourderPopupTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface YourderPopupView : UIView <UITableViewDataSource, UITableViewDelegate, RapidzzUserManagerDelegate, UITextFieldDelegate>

//Dish Detail
@property (weak, nonatomic) IBOutlet UIImageView *imgDish;
@property (weak, nonatomic) IBOutlet UILabel *lblDishName;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UILabel *lblDishPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDishTotal;

//Quantity
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UIButton *btnAddQuantity;
@property (weak, nonatomic) IBOutlet UIButton *btnLessQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtComments;

//Split
@property (weak, nonatomic) IBOutlet UILabel *lblSplitWith;
@property (weak, nonatomic) IBOutlet UILabel *lblYouPay;
@property (weak, nonatomic) IBOutlet UIButton *btnSplitEveryOne;
@property (weak, nonatomic) IBOutlet UITableView *tblUsers;

//Footer
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

//Other Properties
@property (strong, nonatomic) NSMutableArray *arrMenuItems;
@property (strong, nonatomic) NSDictionary *dictItemInfo;
@property NSInteger selectedDishIndex;
@property (strong, nonatomic) NSString *dishSplitUsers;
@property (weak, nonatomic) IBOutlet UIView *tbl_bgview;


//Table Users
@property (strong, nonatomic) RapidzzUserManager *manager;
@property (strong, nonatomic) NSMutableArray *arrUsers;





-(void) bindDishInfo;
-(void) getTableUsers;




@end
