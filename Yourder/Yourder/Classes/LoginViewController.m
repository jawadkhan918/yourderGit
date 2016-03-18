//
//  LoginViewController.m
//  Yourder
//
//  Created by Rapidzz on 15/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController ()
{
    FBSDKLoginManager *loginManager;
    id fbresult;

    
}

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    //FOR GOOGLE SIG IN
    [GIDSignIn sharedInstance].clientID = @"812564942176-u6v9ad0edmjks4h5ebd19j5qcir6k60t.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    
    [self toggleAuthUI];
    [self statusText].text = @"Google Sign in\niOS Demo";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"] != nil)
    {
        [self stayLogin];
    }
        
}
-(IBAction)btnResturantLogin:(id)sender
{
    [self performSegueWithIdentifier:@"gotoResturantLogin" sender:self];
}


-(void)stayLogin
{
    [AppDelegate singleton].loginType = k_Slide_Menu_UserLogin;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    [AppDelegate singleton].userInfo = dict;
    if(dict == nil)
        [self fetchUserInfo];
    else
        [self performSegueWithIdentifier:@"loginToListing" sender:self];
}

- (IBAction)fbLoginButtonClicked:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //[login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error)
        {
            NSLog(@"error %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];  
        }
        else if (result.isCancelled)
        {
            // Handle cancellations
          [MBProgressHUD hideHUDForView:self.view animated:YES];        }
        else
        {
            if ([result.grantedPermissions containsObject:@"email"])
            {
                // Do work
                [self fetchUserInfo];
            }
        }
    }];
}


-(void)registerUserForPushNotification
{
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //[currentInstallation setObject:[PFUser currentUser] forKey:@"User"];
    [currentInstallation setDeviceTokenFromData:[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]];
    [currentInstallation setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"login_email"] forKey:@"email"];
    [currentInstallation setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"login_name"] forKey:@"username"];
    
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
    
}


-(void)fetchUserInfo
{
    //if ([FBSDKAccessToken currentAccessToken])
    
         [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"email,name,birthday,picture.width(100).height(100)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSDictionary *dicParams = @{@"name":[result objectForKey:@"name"]
                                             ,@"email":[result objectForKey:@"email"]
                                             ,@"type":@"fb"
                                             ,@"birthday":@"01-01-2016"//[result objectForKey:@"birthday"]
                                             ,@"profile_picture":[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]};
                 [self loginData:dicParams];
             }
             else
             {
                 NSLog (@"Error %@",error);
             }
         }];
}


-(void) loginData:(NSDictionary *) dict
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", currDate);
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    
    NSDictionary *dicParams = @{@"login_usertoken":@"ABCXYZ-989898"
                                ,@"login_name":[dict objectForKey:@"name"]
                                ,@"login_email":[dict objectForKey:@"email"]
                                ,@"login_type":[dict objectForKey:@"type"]
                                ,@"login_date":currDate
                                ,@"login_time":@"00:00"
                                ,@"profile_picture":[dict objectForKey:@"profile_picture"]
                                ,@"birthday":[dict objectForKey:@"birthday"]};
    [self.manager addLoginLog:dicParams];
}



-(void) didLoginLogSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == k_API_Success || [[dictResult objectForKey:@"status"] integerValue] == k_User_Login_RecordExists)
    {
        [[NSUserDefaults standardUserDefaults]setObject:dictResult forKey:@"user"];
        //[[NSUserDefaults standardUserDefaults]setObject:[dictResult objectForKey:@"order_id"] forKey:@"order_id"];
        [AppDelegate singleton].userInfo = dictResult;
        [AppDelegate singleton].loginType = k_Slide_Menu_UserLogin;
        [self performSegueWithIdentifier:@"loginToListing" sender:self];
        [self registerUserForPushNotification];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
    }
        
}

-(void) didLoginLogFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}


#pragma mark LOGIN WITH FACEBOOK

-(IBAction)loginWithGoogle:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}

-(void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{

    [AppDelegate singleton].loginType = k_Slide_Menu_UserLogin;
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error)
    {
        //aHandler(result, error);
    }];
    
    
    if ([FBSDKAccessToken currentAccessToken])
    {

        // User is logged in
//        [self performSelector:@selector(accessGrantedNavigation)
//                   withObject:nil afterDelay:0.0];
    }
}




-(void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"logout");
}


#pragma mark LOGIN WITH GOOGLE

- (IBAction)didTapSignOut:(id)sender
{
    [[GIDSignIn sharedInstance] signOut];
    [self toggleAuthUI];
}

- (IBAction)didTapDisconnect:(id)sender
{
    [[GIDSignIn sharedInstance] disconnect];
}

- (void)toggleAuthUI
{
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil)
    {
        // Not signed in
        [self statusText].text = @"Google Sign in\niOS Demo";
        //self.signInButton.hidden = NO;
        self.signOutButton.hidden = YES;
        self.disconnectButton.hidden = YES;
    } else
    {
        // Signed in
        //self.signInButton.hidden = YES;
        self.signOutButton.hidden = NO;
        self.disconnectButton.hidden = NO;
    }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    //[myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    [AppDelegate singleton].loginType = k_Slide_Menu_UserLogin;
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSLog(@"Customer details: %@ %@ %@ %@", userId, idToken, name, email);
    
    NSURL *imageURL;
    NSLog(@"Customer details: %@ %@ %@ %@", userId, idToken, name, email);
    
    
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        imageURL =
        [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:500];
        //        NSUInteger dimension = round([[UIScreen mainScreen] scale]);
        //        imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[user.profile imageURLWithDimension:dimension]]];
        
    }
    NSDictionary *dicParams = @{@"name":user.profile.name
                                ,@"email":user.profile.email
                                ,@"type":@"gmail"
                                ,@"birthday":@"01-01-2016"
                                ,@"profile_picture":imageURL
                                
                                };
    //    NSDictionary *dicParams = @{@"name":user.profile.name
    //                                ,@"email":user.profile.email
    //                                ,@"type":@"gmail"};
    //
    //[[NSUserDefaults standardUserDefaults]setObject:dicParams forKey:@"user"];
    
    [self loginData:dicParams];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) receiveToggleAuthUINotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"])
    {
        [self toggleAuthUI];
        self.statusText.text = [notification userInfo][@"statusText"];
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
