//
//  PaymentViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 27/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 

    
}

// PLACE ORDER POPUP

#pragma mark - SEND ORDER TO KITCHEN

- (IBAction)placeOrder:(id)sender
{
    //    if ([AppDelegate singleton].arrCurrOrder.count > 0)
    //    {
    self.alertView = [[CustomIOSAlertView alloc] init];
    self.alertView.tag = 1001;
    //[self.alertView setFrame:CGRectMake(0, 0, 302, 430)];
    [self.alertView setContainerView:[self createPopup:0]];
    
    
    // Modify the parameters
    [self.alertView setButtonTitles:nil];
    [self.alertView setDelegate:self];
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
    //    }
    //    else
    //    {
    //        [[AppDelegate singleton] showAlertwith:nil andMessage:@"There is no dish in the cart"];
    //    }
}

- (UIView *) createPopup: (int) index
{
    UIView *demoView;
    self.objAddCardVCPopup = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceorderVC"];
    //float Y_Co = self.view.frame.size.height - 430;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 302, 430)];
    self.objAddCardVCPopup.view.frame = CGRectMake(0, 0, 302, 430);
    
    //ADD BUTTONS METHODS
    [self.objAddCardVCPopup.btnClose addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.objAddCardVCPopup.btnAddCard addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [demoView addSubview:self.objAddCardVCPopup.view];
    return demoView;
}

//SAVE AND CANCEL BUTTON
-(IBAction)btnCancel:(id)sender
{
    //[self.placeOrderView removeFromSuperview];
    [self.alertView close];
    
}

-(IBAction)btnDone:(id)sender
{
    if ([AppDelegate singleton].arrCurrOrder.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Are you sure you want to submit this order ?"
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO",nil];
        [alert show];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:@"No dish to submit please press cancel"];
    }
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
