//
//  PayBillViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 02/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "PayBillViewController.h"

#define kPayPalEnvironment #define kPayPalEnvironment PayPalEnvironmentSandbox

@interface PayBillViewController () <CardIOPaymentViewControllerDelegate>
{
    NSString *Price;
    float totalAmount;
    NSArray *arrUserDishes;
    NSDictionary *serviceResponse;
    int subTotal;
    int tax;
    float Totaltax;

    
}

@property (nonatomic,strong ) UIImage * image;
@property BOOL Check;



@end

@implementation PayBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tbl_bgView.layer.cornerRadius= self.tbl_bgView.frame.size.width / 20;
    self.tbl_bgView.layer.masksToBounds = YES;
    self.tbl_bgView.clipsToBounds = YES;
    
    self.viewTip_bg.layer.cornerRadius= self.viewTip_bg.frame.size.width / 20;
    self.viewTip_bg.layer.masksToBounds = YES;
    self.viewTip_bg.clipsToBounds = YES;
    
    self.environment = [NSString stringWithFormat:@"mock"];
    //self.environment = PayPalEnvironmentSandbox;

    self.Check = YES;
    _image= [UIImage imageNamed:@"correct_sign.png"];
    
    
    //GET ORDER DETAIL FROM DB
    [self getDishes];
    
    
    //GHAFAR CODE
    self.manager.delegate = self;
    totalAmount =0;
    tax = 1;
    subTotal =0;

    //BIND RESTAURANT AND USER INFO
    [self bindRestaurantInfo];
    self.tipSegment.selectedSegmentIndex = 0;
    [self.tipSegment addTarget:self action:@selector(calculateTip:) forControlEvents:UIControlEventValueChanged];
    
    //SLIDEBAR VIEW
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //BRAIN TREE METHOD
    [self BrainTreeClientToken];
}


#pragma mark - GET ORDER DETAIL

-(void)getDishes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    arrUserDishes = [[NSArray alloc] init];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    //NSLog(@"dict%@",[AppDelegate singleton].userInfo);
    NSDictionary *dict = @{@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                           ,@"status":@"1"};
    [self.manager getUserDishes:dict];
}

-(void)DidGetUserDishesSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    serviceResponse = manager.data;
    arrUserDishes = [manager.data objectForKey:@"order_detail"];
    [self.tblOrder reloadData];
    for (int i = 0; i<arrUserDishes.count; i++)
    {
        totalAmount = totalAmount + [[[arrUserDishes objectAtIndex:i] objectForKey:@"uPay"] floatValue];
    }
    
    NSString *strAmount = @"$";
    self.lblTotalAmount.text = [strAmount stringByAppendingString:[NSString stringWithFormat:@"%.02f",totalAmount]];
    float TotalTip = (totalAmount * 10)/100;
    self.txtTip.text = [NSString stringWithFormat:@"$%.02f", TotalTip];
    
    Totaltax = (totalAmount * 17)/100;
    self.txtTax.text = [NSString stringWithFormat:@"$%.02f", Totaltax];
    
    self.lblGrandTotal.text = [NSString stringWithFormat:@"$%.02f",(totalAmount + TotalTip + Totaltax)];
            [self.btnCancel setTitle:self.lblTotalAmount.text forState:UIControlStateNormal];
}

-(void)DidFailToGetUserDishes:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void) BrainTreeClientToken
{
    NSURL *clientTokenURL = [NSURL URLWithString:@"http://www.pakwedds.com/Resturant/braintree_token.php"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData  *_Nullable data, NSURLResponse   *_Nullable response, NSError *_Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"client token %@",clientToken);
        self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
        // As an example, you may wish to present our Drop-in UI at this point.
        // Continue to the next section to learn more...
    }] resume];
}


-(void) bindRestaurantInfo
{
    //RESTAURANT INFO BINDING
    self.lblRestName.text = [[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_name"];
    self.lblRestAddress.text = [[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_address"];
    
    NSURL *logoImageURL = [NSURL URLWithString:[[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_logo"]];
    [self.imgRestLogo setImageWithURL:logoImageURL];
    self.imgRestLogo.layer.cornerRadius= self.imgRestLogo.frame.size.width / 2;
    self.imgRestLogo.layer.masksToBounds = YES;
    self.imgRestLogo.clipsToBounds = YES;
    
    //PERSONAL INFO BINDING
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSURL *userProfileImage = [NSURL URLWithString:[dict objectForKey:@"profile_picture"]];
    [self.imgUserthumb setImageWithURL:userProfileImage];
    self.imgUserthumb.layer.cornerRadius= self.imgUserthumb.frame.size.width / 2;
    self.imgUserthumb.layer.masksToBounds = YES;
    self.imgUserthumb.clipsToBounds = YES;
    
    self.lblUsername.text = [dict objectForKey:@"login_name"];

}


-(void)PaypalButtonClicked
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dictParams = @{@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                                 , @"barcode_value":[AppDelegate singleton].userTableBarcode};
    
    
    [self.manager PayAmountFromPaypal:dictParams];
}


-(void)DidPayAmountSuccessfully:(RapidzzBaseManager *)manager
{
    
    NSDictionary *dict = manager.data;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([[dict objectForKey:@"status"] intValue] == 0 )
    {
        [AppDelegate singleton].previousOrderId = 0;
        [self rateRestaurant:self];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:@"message"];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass: [SWRevealViewControllerSegue class]])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}


-(void)DidFailToPayAmount:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    NSLog(@"unsuccessfull");
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


# pragma mark - TABLE DELEGATES

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrUserDishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    YourorderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[YourorderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:MyIdentifier];
    }
    
    
    NSDictionary *dict = [arrUserDishes objectAtIndex:indexPath.row];
    cell.lblDishName.text = [dict objectForKey:@"item_name"];
    cell.lblYouPay.text = [NSString stringWithFormat:@"%.02f",[[dict objectForKey:@"uPay"] floatValue]];
//    cell.txtCount.text = [dict objectForKey:@"count"];
//    cell.lblDishPrice.text = [NSString stringWithFormat:@"%@ x $ %@",[dict objectForKey:@"quantity"],[dict objectForKey:@"item_price"]];
    
//    //DISH TOTAL
//    float DishTotal =  [[dict objectForKey:@"item_price"] floatValue] * [[dict objectForKey:@"quantity"] floatValue];
//    cell.lblDishTotal.text = [NSString stringWithFormat:@"$ %.02f", DishTotal];
//    
//    // YOU PAY
//    NSUInteger numberOfOccurrences;
//    float youpay;
//    if ([[dict objectForKey:@"splitwith"] isEqualToString:@"0"])
//    {
//        numberOfOccurrences = 0;
//        youpay = DishTotal;
//        cell.lblSplitWith.text = @"";
//    }
//    else
//    {
//        numberOfOccurrences = [[[dict objectForKey:@"splitwith"] componentsSeparatedByString:@","] count];
//        youpay = DishTotal / (numberOfOccurrences+1);
//        cell.lblSplitWith.text = [NSString stringWithFormat:@"Split with %lu persons", (unsigned long)numberOfOccurrences];
//    }
    
    //cell.lblYouPay.text = [NSString stringWithFormat:@"$%.02f", youpay];
    
    //totalAmount = totalAmount +youpay;
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)calculateTip:(id)sender
{
    int tip;
    if (self.tipSegment.selectedSegmentIndex == 0)
    {
        tip = 10;
    }
    else if(self.tipSegment.selectedSegmentIndex == 1)
    {
        tip = 12;
    }
    else if(self.tipSegment.selectedSegmentIndex == 2)
    {
        tip = 15;
    }
    
    double TotalTip = (totalAmount * tip)/100;
    self.txtTip.text = [NSString stringWithFormat:@"$%.02f", TotalTip];
    self.lblGrandTotal.text = [NSString stringWithFormat:@"$%.02f",(totalAmount + TotalTip + Totaltax)];
}


#pragma mark PAYPAL METHODS

-(IBAction)btnPayapal:(id)sender
{
    self.resultText = nil;
}
#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
}


#pragma mark - Authorize Profile Sharing

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization
{
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}


// RATE RESTAURANT

#pragma mark - RATE RESTAURANT

- (IBAction)rateRestaurant:(id)sender
{
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
}

- (UIView *) createPopup: (int) index
{
    UIView *demoView;
    _objRatingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ratingAlertVC"];
    //float Y_Co = self.view.frame.size.height - 430;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    _objRatingView.view.frame = CGRectMake(0, 0, 250, 250);
    
    //ADD BUTTONS METHODS
    [_objRatingView.btnClose addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_objRatingView.btnRate addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [demoView addSubview:_objRatingView.view];
    return demoView;
}

//SAVE AND CANCEL BUTTON
-(IBAction)btnCancel:(id)sender
{
    [[AppDelegate singleton].arrPlacedOrder removeAllObjects];
    [self performSegueWithIdentifier:@"payToListing" sender:self];
    [self.alertView close];
}

-(IBAction)btnDone:(id)sender
{
    [self.objRatingView addRestaurantRating];
    [[AppDelegate singleton].arrPlacedOrder removeAllObjects];
    [self performSegueWithIdentifier:@"payToListing" sender:self];
    [self.alertView close];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - BRAIN TREE METHODS AND DELEGATES

- (IBAction)tappedMyPayButton {
    
    // If you haven't already, create and retain a `BTAPIClient` instance with a tokenization
    // key or a client token from your server.
    // Typically, you only need to do this once per session.
    //self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:aClientToken];
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    
    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    [self postNonceToServer:paymentMethodNonce.nonce];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    // Update URL with your server
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    NSDictionary *dictRequest = @{
                                  @"payment_method_nonce":paymentMethodNonce
                                  ,@"amount":@"50"
                                  ,@"rest_id":[[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_id"]};
    
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    [self.manager getPaymentStatus:dictRequest];
}

-(void)DidGetPaymentStatusSuccessfully:(RapidzzBaseManager *)manager
{
    
    NSLog(@"successfull %@",manager.data);
    [self PaypalButtonClicked];
}

-(void)DidFailToGetPaymentStatus:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    NSLog(@"failed");
}








- (void)didReceiveMemoryWarning
{
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
