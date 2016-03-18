//
//  NotificationTableViewCell.h
//  Yourder
//
//  Created by Arslan Ilyas on 23/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSender;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UIButton *btn_decline;
@property (weak, nonatomic) IBOutlet UIButton *btn_order;



@end
