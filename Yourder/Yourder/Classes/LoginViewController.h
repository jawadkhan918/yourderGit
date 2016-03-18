//
//  LoginViewController.h
//  Yourder
//
//  Created by Rapidzz on 15/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn.h>

@interface LoginViewController : UIViewController <FBSDKLoginButtonDelegate, FBSDKLoginTooltipViewDelegate, GIDSignInUIDelegate, RapidzzUserManagerDelegate, GIDSignInDelegate>

// LOGIN WITH FB
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

// LOGIN WITH GOOGLE
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
@property (strong, nonatomic) RapidzzUserManager *manager;


@property (weak, nonatomic) IBOutlet UIButton *btnResturantLogin;

-(IBAction)loginWithGoogle:(id)sender;

@end
