//
//  RestaurantMenuViewController.h
//  Yourder
//
//  Created by Rapidzz on 24/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pagerChildViewController.h"
#import "DishesTableViewCell.h"
#import "SWRevealViewController.h"
#import "YourorderViewController.h"
#import "RightSliderViewController.h"
#import "ServiceRequestViewController.h"


@interface RestaurantMenuViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, RapidzzUserManagerDelegate, CustomIOSAlertViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *dictSelectedRestaurant;
@property (weak, nonatomic) IBOutlet UIScrollView *scrCatgories;
@property (weak, nonatomic) IBOutlet UIScrollView *scrDishes;
@property (weak, nonatomic) IBOutlet UIView *viewDishes;
@property (assign, nonatomic) BOOL shouldReturn;

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) RapidzzUserManager *manager;
@property (strong, nonatomic) NSMutableArray *arrCategories;

//RESTAURANT INFO
@property (weak, nonatomic) IBOutlet UIImageView *imgRest;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblRestName;
@property (weak, nonatomic) IBOutlet UILabel *lblRestAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnServiceRequest;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalItems;
@property (weak, nonatomic) IBOutlet UIButton *btnYourOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitOrder;

@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;

//POP UP
@property (strong, nonatomic) YourorderViewController *objYourderView;
@property (strong, nonatomic) RightSliderViewController *objSliderView;
@property (strong, nonatomic) ServiceRequestViewController *objServiceView;
@property (nonatomic,strong) CustomIOSAlertView *alertView;
@property (strong, nonatomic) UIView *rightSliderView;
@property (strong, nonatomic) UIView *placeOrderView;
@property (weak, nonatomic) IBOutlet UIView *viewOrderList;


@property (weak, nonatomic) IBOutlet UIButton *btnRightSlider;
@property (strong, nonatomic) UILabel *lblItemCount;

@property (strong, nonatomic) IBOutlet UIButton *btnPlaceOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblItemsCount;












@end
