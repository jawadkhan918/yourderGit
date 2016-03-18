//
//  YourorderTableViewCell.h
//  Yourder
//
//  Created by Kamran Butt on 1/12/16.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourorderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDishName;
@property (weak, nonatomic) IBOutlet UITextField *txtCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDishPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDishTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblSplitWith;
@property (weak, nonatomic) IBOutlet UILabel *lblYouPay;

@property (weak, nonatomic) IBOutlet UIButton *btnRemove;




@end
