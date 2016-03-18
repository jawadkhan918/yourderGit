//
//  PayBillViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 02/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CardIOPaymentViewControllerDelegate.h"
#import "YourorderTableViewCell.h"
#import "SWRevealViewController.h"
#import "CustomIOSAlertView.h"
#import "RatingViewController.h"

//BRAIN TREE CLASSES
#import <Braintree/BraintreeUI.h>
#import <Braintree/BraintreeCore.h>



@interface PayBillViewController : UIViewController <RapidzzUserManagerDelegate, UITextFieldDelegate, CustomIOSAlertViewDelegate, BTDropInViewControllerDelegate>


-(void)setPayPalEnvironment:(NSString *)environment;

@property (strong, nonatomic) RapidzzUserManager *manager;

@property (strong, nonatomic) NSDictionary *dictSelectedRestaurant;
@property (weak, nonatomic) IBOutlet UILabel *lblRestName;
@property (weak, nonatomic) IBOutlet UILabel *lblRestAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgRestLogo;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserthumb;

@property (weak, nonatomic) IBOutlet UILabel *lblTableNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTablePersons;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UITableView *tblOrder;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (weak, nonatomic) IBOutlet UITextField *txtTip;
@property (weak, nonatomic) IBOutlet UITextField *txtTax;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSegment;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *lblGrandTotal;

@property (weak, nonatomic) IBOutlet UIView *tbl_bgView;
@property (weak, nonatomic) IBOutlet UIView *viewTip_bg;

@property (strong, nonatomic) RatingViewController *objRatingView;
@property (nonatomic,strong) CustomIOSAlertView *alertView;


//BRAIN TREE PROPERTIES
@property (nonatomic, strong) BTAPIClient *braintreeClient;












// Paypal
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (strong, nonatomic) IBOutlet UIScrollView *scrwPaypal;


@property (nonatomic,strong) NSString * strStatus;
@property (nonatomic,strong) NSString * offerid;
@property (nonatomic,strong) NSString * transactionId;
@property (nonatomic,strong) NSString * totalapyment;


- (IBAction)btnPayapal:(id)sender;


@end
