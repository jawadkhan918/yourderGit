//
//  RestaurantDetailViewController.h
//  Yourder
//
//  Created by Rapidzz on 21/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "barcodeView.h"
#import "CustomIOSAlertView.h"
#import "RestaurantMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RatingViewController.h"

@interface RestaurantDetailViewController : UIViewController <CustomIOSAlertViewDelegate, AVCaptureMetadataOutputObjectsDelegate, RapidzzUserManagerDelegate>

@property (strong, nonatomic) NSDictionary *dictSelectedRestaurant;
@property (weak, nonatomic) IBOutlet UIImageView *restImg;
@property (weak, nonatomic) IBOutlet UIImageView *restLogo;
@property (weak, nonatomic) IBOutlet UILabel *restName;
@property (weak, nonatomic) IBOutlet UILabel *restAddress;
@property (weak, nonatomic) IBOutlet UILabel *restCity;
@property (weak, nonatomic) IBOutlet UILabel *restPostCode;
@property (weak, nonatomic) IBOutlet UILabel *restLat;
@property (weak, nonatomic) IBOutlet UILabel *restLont;
@property (weak, nonatomic) IBOutlet UILabel *restFoodType;
@property (weak, nonatomic) IBOutlet UILabel *restDetail;
@property (strong, nonatomic) barcodeView *objBarcodeView;
@property (nonatomic,strong) CustomIOSAlertView *alertView;
@property (strong, nonatomic) RapidzzUserManager *manager;


-(UIView *) createBarcode;
-(IBAction) callBarcode:(id)sender;



@end
