//
//  DishesTableViewCell.h
//  Yourder
//
//  Created by Rapidzz on 09/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgDishthumb;
@property (weak, nonatomic) IBOutlet UILabel *lblDishName;
@property (weak, nonatomic) IBOutlet UILabel *lblDishDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblDishPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;



@end
