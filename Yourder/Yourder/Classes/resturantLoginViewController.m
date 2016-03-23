//
//  resturantLoginViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 25/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "resturantLoginViewController.h"

@interface resturantLoginViewController ()
{
    NSString *strUserName;
    NSString *strPassword;
    BOOL    setPosition;
    BOOL checkUserName;
    BOOL checkPassword;
    NSDictionary *dictResult;
    
}

@end

@implementation resturantLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //strUserName = @"ghafar.tanveer.3";
   // strPassword = @"12345";
    UIColor *color = [UIColor whiteColor];
    self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtUserName.placeholder attributes:@{NSForegroundColorAttributeName: color}];
     self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtPassword.placeholder attributes:@{NSForegroundColorAttributeName: color}];
   
}
-(IBAction)btnLogin:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    
    NSDictionary *dicParams = @{@"email":self.txtUserName.text
                                ,@"pass":self.txtPassword.text
                                };
    [self.manager ResturantLogin:dicParams];
}
- (IBAction)backtohome:(id)sender
{
    [self performSegueWithIdentifier:@"backtohome" sender:self];
}

-(void) DidResturantLoginSuccessfully:(RapidzzBaseManager *)manager;
{
    dictResult = manager.data;
    [AppDelegate singleton].Rest_key = [NSString stringWithFormat:@"%@",[dictResult objectForKey:@"rest_id"]
                                        ];
    [AppDelegate singleton].User_id = [NSString stringWithFormat:@"%@",[dictResult objectForKey:@"staff_id"]];
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AppDelegate singleton].loginType = k_Slide_Menu_RestaurantLogin;
        [AppDelegate singleton].dictLogedInRestaurantInfo = dictResult;
        [AppDelegate singleton].Waiter_Name = [manager.data objectForKey:@"staff_name"];
        [self performSegueWithIdentifier:@"WaiterDetailVC" sender:self];
        [self registerUserForPushNotification];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[dictResult objectForKey:@"Message"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
 
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) DidFailToResturantLogin:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    setPosition = YES;
    self.view.frame = CGRectMake( 0, -100, self.view.frame.size.width, self.view.frame.size.height );
    
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(setPosition == NO)
        self.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    setPosition = NO;
    [textField resignFirstResponder];
    return YES;
}

// REGISTER FOR NOTIFICATION

-(void)registerUserForPushNotification
{
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //[currentInstallation setObject:[PFUser currentUser] forKey:@"User"];
    [currentInstallation setDeviceTokenFromData:[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]];
    [currentInstallation setValue:[NSString stringWithFormat:@"%@@%@.com",[dictResult objectForKey:@"staff_name"],[dictResult objectForKey:@"rest_name"]] forKey:@"email"];
    [currentInstallation setValue:[dictResult objectForKey:@"staff_name"] forKey:@"username"];
    
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
    
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
