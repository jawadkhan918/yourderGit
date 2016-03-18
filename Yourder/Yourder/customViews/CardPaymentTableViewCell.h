//
//  CardPaymentTableViewCell.h
//  Yourder
//
//  Created by Ghafar Tanveer on 29/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardPaymentTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *lblName;
@property (weak,nonatomic) IBOutlet UILabel *lblCardNo;
@property (weak,nonatomic) IBOutlet UILabel *lblExpiryDate;


@end
