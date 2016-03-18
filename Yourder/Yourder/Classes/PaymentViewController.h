//
//  PaymentViewController.h
//  Yourder
//
//  Created by Arslan Ilyas on 27/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCardViewController.h"

@interface PaymentViewController : UIViewController <CustomIOSAlertViewDelegate>

@property (nonatomic,strong) CustomIOSAlertView *alertView;
@property (strong, nonatomic) AddCardViewController *objAddCardVCPopup;

- (IBAction)placeOrder:(id)sender;

@end
