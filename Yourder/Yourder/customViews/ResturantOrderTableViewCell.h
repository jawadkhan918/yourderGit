//
//  ResturantOrderTableViewCell.h
//  Yourder
//
//  Created by Kamran Butt on 1/28/16.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResturantOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTableBarcode;
@property (weak, nonatomic) IBOutlet UILabel *lblTableNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveUser;
@property (weak, nonatomic) IBOutlet UIView *userView;


@end
