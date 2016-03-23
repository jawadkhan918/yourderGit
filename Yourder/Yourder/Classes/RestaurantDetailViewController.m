//
//  RestaurantDetailViewController.m
//  Yourder
//
//  Created by Rapidzz on 21/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "BarcodeViewController.h"
#import "barcodeView.h"
#import "RestaurantMenuViewController.h"

@interface RestaurantDetailViewController ()
{
    // BARCODE VIEW VARIABLES
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    UIButton *_btnClose;
    
    UIView *_highlightView;
    UILabel *_label;
    NSString *barcodeValue;
    UITextView *txtDetail;
    
    AppDelegate *delegate;
    
}

@end


@implementation RestaurantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    barcodeValue = @"";
    
    txtDetail = [[UITextView alloc] init];
    [self.view addSubview:txtDetail];
    txtDetail.font = [UIFont fontWithName:@"Roboto-Bold 11.0" size:11.0];
    txtDetail.keyboardType = UIKeyboardTypeAlphabet;
    txtDetail.returnKeyType = UIReturnKeyDone;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        txtDetail.frame = CGRectMake(65, 457, 243, 53);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        [txtDetail setFrame:CGRectMake(65, 465, 280, 120)];
        self.view.autoresizesSubviews = YES;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        txtDetail.frame = CGRectMake(64, 465, 280, 130);
    }
    
    [self restaurantDetail];
    
}


-(void) restaurantDetail
{
    
    NSURL *agentImageURL = [NSURL URLWithString:[self.dictSelectedRestaurant objectForKey:@"rest_thumbnail"]];
    [self.restImg setImageWithURL:agentImageURL];
    self.restName.text = [self.dictSelectedRestaurant objectForKey:@"rest_name"];
    self.restAddress.text = [self.dictSelectedRestaurant objectForKey:@"rest_address"];
    self.restCity.text = [NSString stringWithFormat:@"City / State: %@",[self.dictSelectedRestaurant objectForKey:@"rest_city"]];
    self.restPostCode.text = [NSString stringWithFormat:@"Post code: %@", [self.dictSelectedRestaurant objectForKey:@"rest_postcode"]];
    
    NSArray *latlong = [[self.dictSelectedRestaurant objectForKey:@"rest_latlong"] componentsSeparatedByString:@","];
    self.restLat.text = [NSString stringWithFormat:@"Latitude: %@", [NSString stringWithFormat:@"%@",[latlong objectAtIndex:0]]];
    self.restLont.text = [NSString stringWithFormat:@"Longitude: %@", [NSString stringWithFormat:@"%@",[latlong objectAtIndex:1]]];
    //self.restLont.text = [[latlong objectAtIndex:1] stringValue];
    //self.restDetail.text = [self.dictSelectedRestaurant objectForKey:@"rest_detail"];
    txtDetail.text = [self.dictSelectedRestaurant objectForKey:@"rest_detail"];
    self.restFoodType.text = [self.dictSelectedRestaurant objectForKey:@"rest_type"];
    
    
    NSURL *logoImageURL = [NSURL URLWithString:[self.dictSelectedRestaurant objectForKey:@"rest_logo"]];
    [self.restLogo setImageWithURL:logoImageURL];
    self.restLogo.layer.cornerRadius= self.restLogo.frame.size.width / 2;
    self.restLogo.layer.masksToBounds = YES;
    self.restLogo.clipsToBounds = YES;
}

- (IBAction)showBarcodeView:(id)sender
{
    // Here we need to pass a full frame
    self.alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [self.alertView setContainerView:[self createBarcode]];
    
    // Modify the parameters
    [self.alertView setButtonTitles:nil];
    //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", nil]];
    [self.alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    //    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
    //        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
    //        [alertView close];
    //    }];
    
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
}

- (UIView *) createBarcode
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 350)];
    
    _objBarcodeView = [[[NSBundle mainBundle] loadNibNamed:@"barcode" owner:self options:nil] objectAtIndex:0];
    _objBarcodeView.tag = 1001;
    _objBarcodeView.frame = CGRectMake(0, 0, 280, 350);
    _objBarcodeView.layer.cornerRadius = 7;
    _objBarcodeView.layer.masksToBounds = YES;
    //_objBarcodeView.ddclientJobs.itemList = arrClientJobs ;
    //[self addToolBarToPickerView:_rootView.ddclientJobs];
    
    //ADD BUTTONS METHODS
    [_objBarcodeView.btnClose addTarget:self action:@selector(closeBarcodeView:) forControlEvents:UIControlEventTouchUpInside];
    [_objBarcodeView.btnOpenCamera addTarget:self action:@selector(callBarcode:) forControlEvents:UIControlEventTouchUpInside];
    [_objBarcodeView.btnGo addTarget:self action:@selector(btnGo:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (![barcodeValue isEqualToString:@""])
//    {
//        _objBarcodeView.txtBarcode.text = barcodeValue;
//        barcodeValue = @"";
//    }
    
    
    [demoView addSubview:_objBarcodeView];
    return demoView;
}


# pragma mark - UIBUTTONS METHODS


-(IBAction)closeBarcodeView:(id)sender
{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.alertView close];
}


-(IBAction)callBarcode:(id)sender
{
    // ADD CAMERA VIEW
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    
    /*
    // ADD LABEL
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
    */
     
    
    // ADD CLOSE BUTTON
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClose addTarget:self
               action:@selector(closeScanner:)
     forControlEvents:UIControlEventTouchUpInside];
    [_btnClose setTitle:@"Cancel" forState:UIControlStateNormal];
    _btnClose.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _btnClose.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:12.0/255.0 blue:0/255.0 alpha:1];
    [self.view addSubview:_btnClose];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input)
    {
        [_session addInput:_input];
    }
    else
    {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
    [self.view bringSubviewToFront:_btnClose];
    
    //[self closeBarcodeView:self];
    self.alertView.hidden = YES;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            [_btnClose removeFromSuperview];
            _label.text = detectionString;
            barcodeValue = detectionString;
            [_highlightView removeFromSuperview];
            [_prevLayer removeFromSuperlayer];
            [_label removeFromSuperview];
            
            _objBarcodeView.txtBarcode.text = detectionString;
            self.alertView.hidden = NO;
            
            
            
            break;
        }
        else
            _label.text = @"(none)";
        
    }
    
    _highlightView.frame = highlightViewRect;
}


-(IBAction)closeScanner:(id)sender
{
    [_highlightView removeFromSuperview];
    [_prevLayer removeFromSuperlayer];
    [_label removeFromSuperview];
    [_btnClose removeFromSuperview];
}

#pragma mark ADD TABLE USERS


-(IBAction)btnGo:(id)sender
{
    if (_objBarcodeView.txtBarcode.text.length <= 0)
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:@"Please scan or enter barcode"];
        return;
    }
    
    [self AddTableUser];
}


-(void) AddTableUser
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    
    NSDictionary *dictParams = @{@"rest_id":[self.dictSelectedRestaurant objectForKey:@"rest_id"],
                                 @"login_id":[dict objectForKey:@"login_id"], //@"3", //[AppDelegate singleton]. //@"3",
                                 @"user_status":@"1",
                                 @"user_billpaid":@"1",
                                 @"user_active":@"0",
                                 @"barcode_value":_objBarcodeView.txtBarcode.text};
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager addTableUser:dictParams];
    [MBProgressHUD showHUDAddedTo:self.alertView animated:YES];
}


-(void) didAddTableUserSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.alertView animated:YES];
    [AppDelegate singleton].userTableBarcode = _objBarcodeView.txtBarcode.text;
    
    NSDictionary *dictResult = manager.data;
    [AppDelegate singleton].dictUserPreviousOrderDetail = manager.data;
    
    if ([[dictResult objectForKey:@"status"] intValue] == k_API_Success || [[dictResult objectForKey:@"status"] intValue] == k_barcode_User_already_Ontable)
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
        [AppDelegate singleton].previousOrderId = [[dictResult objectForKey:@"order_id"] intValue];
        [AppDelegate singleton].totalBillAmount = [[dictResult objectForKey:@"total_price"] floatValue];
        [AppDelegate singleton].table_waiter = [dictResult objectForKey:@"staff_name"];
        
        [self performSegueWithIdentifier:@"BarcodeToRestaurantmenu" sender:self];
    }
    if ([[dictResult objectForKey:@"status"] intValue])
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
    }
    [self closeBarcodeView:self];
}

-(void) didAddTableUserFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.alertView animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RestaurantMenuViewController *detailVC = [segue destinationViewController];
    detailVC.dictSelectedRestaurant = self.dictSelectedRestaurant;
}


-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
