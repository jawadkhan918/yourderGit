//
//  RestaurantTableViewCell.h
//  Yourder
//
//  Created by Rapidzz on 17/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface RestaurantTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *lblRestaurantName;
@property (weak, nonatomic) IBOutlet UILabel *lblRestaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCaisuineType;
@property (weak, nonatomic) IBOutlet UILabel *lblRatingValue;
@property (weak, nonatomic) IBOutlet UIImageView *imgRetaurantLogo;
@property (nonatomic, strong) IBOutlet ASStarRatingView * ratingView;
@property (weak, nonatomic) IBOutlet UILabel *rest_distabce;





@end
