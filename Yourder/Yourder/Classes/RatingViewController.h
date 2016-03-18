//
//  RatingViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 17/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"
#import "UIImageView+WebCache.h"

@interface RatingViewController : UIViewController <RapidzzUserManagerDelegate>

@property (nonatomic, strong) IBOutlet ASStarRatingView * ratingView;
@property (nonatomic, strong) IBOutlet UIImageView *imgLogo ;
@property (nonatomic, strong) IBOutlet UILabel *lblRestName;
@property (nonatomic, strong) IBOutlet UILabel *lblRestAddress;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;
@property (nonatomic, strong) IBOutlet UIButton *btnRate;

@property (strong, nonatomic) RapidzzUserManager *manager;



-(void) addRestaurantRating;

@end
