//
//  UserOrderTableViewCell.h
//  Yourder
//
//  Created by Arslan Ilyas on 11/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_name;
@property (weak, nonatomic) IBOutlet UILabel *des_name;
@property (weak, nonatomic) IBOutlet UIButton *btnServed;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgServed;
@property (weak, nonatomic) IBOutlet UIImageView *imgDelete;



@property (weak, nonatomic) IBOutlet UIButton *count_img;

@end
