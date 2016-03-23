//
//  AppDelegate.m
//  Yourder
//
//  Created by Rapidzz on 15/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleSignIn.h>


@interface AppDelegate ()
{
    int strNotificationId;
}

@end

@implementation AppDelegate


+(AppDelegate*)singleton
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (AppDelegate *)returnAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



// ALERT MESSAGES
-(void)showAlertwith:(NSString *)Title andMessage:(NSString *)message{
    if ([message isKindOfClass:[NSNull class]] || [message isEqual:[NSNull null]] || !message) {
        message = @"Server not responding";
        [self showHudMessage:message];
        return;
    }
    if (alert!=nil)
    {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    alert = [[UIAlertView alloc]initWithTitle:Title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    //[self performSelectorOnMainThread:@selector(hideAlert) withObject:alert waitUntilDone:YES];
    [self performSelector:@selector(hideAlert) withObject:alert afterDelay:2.5];
    //[self perfo]
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideAlert) userInfo:nil repeats:NO];
    
    
}
-(void)hideAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)showHudMessage:(NSString*)message{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithWindow:self.window];
    if ([message isKindOfClass:[NSNull class]] || [message isEqual:[NSNull null]] || !message) {
        message = @"Server not responding";
    }
    //hud.square = YES;
    hud.detailsLabelText = message;
    //hud.detailsLabelText = message;
    [hud hide:YES afterDelay:2.0];
    //[self.window.rootViewController.navigationController.view addSubview:hud];
    [self.window addSubview:hud];
    //hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    //[hud show:NO];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.addedDishIndex = 0;
    self.userTableBarcode = @"";
    self.strUsersId = @"";
    self.totalBillAmount = 0.0;
    self.loginType = k_Slide_Menu_NotLogin;
    
    //SET UI NAVIGATIONBAR BACKGROUND COLOR
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:204.0/255.0 green:12.0/255.0 blue:0/255.0 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    self.selectedCatId = @"";
    self.arrCurrOrder = [[NSMutableArray alloc] init];
    self.arrPlacedOrder = [[NSMutableArray alloc] init];
    self.arrPersons = [[NSMutableArray alloc]init];
    self.arrSelectedTabels = [[NSMutableArray alloc]init];
    
    // FOR FB
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError* configureError;
    //[[EAGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    
//    //FOR GOOGLE SIG IN
//    [GIDSignIn sharedInstance].clientID = @"812564942176-u6v9ad0edmjks4h5ebd19j5qcir6k60t.apps.googleusercontent.com";
//    [GIDSignIn sharedInstance].delegate = self;
    

    
    //PARSE.COM YOURDER APP ID FOR PUSH NOTIFICATION
    [Parse setApplicationId:@"amEdJ6pOOkQQ6DszC9Nh6TXVUrnDhavSHiStIvin"
                  clientKey:@"05gFNVmfs40dn0wszsbNNB6YbjG8Tdn6tP3GgGJC"];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    //YOURDER CLIENT ID
    //[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",PayPalEnvironmentSandbox :@"AdIqur-vlwI9jkVM1sagSTSXk6a72SIh76DIdZBebrWjB-iq2v_Gi8zU9xf2X3w-0tk-XH8JYFYXix8V"}];
    
    //COURIER CLIENT ID
    //[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",PayPalEnvironmentSandbox :@"AT0HXo573JR88tSgnGCFS741_kB9OlUrOksC6C10YhVQj_yyEoA5pspz_pVAMZcJW4M52eiwYGTJ2zsK"}];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //[currentInstallation setValue:@"abdulkarim.khan@hotmail.com" forKey:@"email"];
    //[cur`rentInstallation setValue:@"abdul karim khan" forKey:@"username"];
    
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"deviceToken"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //[PFPush handlePush:userInfo];
    /*
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive ||
        [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        [PFPush handlePush:userInfo];
    }
    else
    {
        [self SplitNotification:userInfo];
    }
    */
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[PFPush handlePush:userInfo];
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive || [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        [PFPush handlePush:userInfo];
    }
    else
    {
        [self SplitNotification:userInfo];
    }
    
    //[PFPush handlePush:userInfo];
    
}

#pragma mark - Split Notification Popup

- (IBAction)SplitNotification:(id)sender
{
    strNotificationId =  (int)[[sender objectForKey:@"notification_id"] integerValue];
    
    self.alertView = [[CustomIOSAlertView alloc] init];
    self.alertView.tag = 1001;
    //[self.alertView setFrame:CGRectMake(0, 0, 302, 430)];
    [self.alertView setContainerView:[self createPopup:sender]];
    
    
    // Modify the parameters
    [self.alertView setButtonTitles:nil];
    [self.alertView setDelegate:self];
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
    
    /*
    
    if([strTitle isEqualToString:@"Decline"])
    {
        [self btnCancel];
    }
    else if([strTitle isEqualToString:@"Split"])
    {
        [self btnDone];
    }
    */
}

- (UIView *) createPopup: (id)sender
{
    UIView *demoView;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    _objSplitNotification = [storyboard instantiateViewControllerWithIdentifier:@"splitNotificationPopup"];
    //float Y_Co = self.view.frame.size.height - 430;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    _objSplitNotification.view.frame = CGRectMake(0, 0, 250, 150);
    
    //ADD BUTTONS METHODS
    [_objSplitNotification.btnClose addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    _objSplitNotification.btnClose.tag = [[sender objectForKey:@"notification_id"] intValue];
    
    [_objSplitNotification.btnSplit addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    _objSplitNotification.btnSplit.tag = [[sender objectForKey:@"notification_id"] intValue];
    
    //SET NOTIFICATION POPUP VALUES FROM HERE
    _objSplitNotification.lblDishName.text = [NSString stringWithFormat:@"Split %@", [sender objectForKey:@"item_name"]];
    _objSplitNotification.lblUsername.text = [NSString stringWithFormat:@"with %@", [sender objectForKey:@"login_name"]];
    
    
    if ([[sender objectForKey:@"profile_picture"] length] > 10)
    {
        NSURL *logoImageURL = [NSURL URLWithString:[sender objectForKey:@"profile_picture"]];
        [_objSplitNotification.imgLogo setImageWithURL:logoImageURL];
        
    }
    else
    {
        _objSplitNotification.imgLogo.image = [UIImage imageNamed:@"icon-person-notification.png"];
    }
    
    _objSplitNotification.imgLogo.layer.cornerRadius= _objSplitNotification.imgLogo.frame.size.width / 2;
    _objSplitNotification.imgLogo.layer.masksToBounds = YES;
    _objSplitNotification.imgLogo.clipsToBounds = YES;
    
    
    [demoView addSubview:_objSplitNotification.view];
    return demoView;
}

//SAVE AND CANCEL BUTTON
-(IBAction)btnCancel:(id)sender
{
   // int NotifiId = (int)((UIButton *)sender).tag;
    strNotificationId =  (int)[[sender objectForKey:@"notification_id"] integerValue];
    [self splitReject:strNotificationId];
    [self.objSplitNotification removeFromParentViewController];
    [self.alertView close];
}

-(IBAction)btnDone:(id)sender
{
    strNotificationId =  (int)[[sender objectForKey:@"notification_id"] integerValue];
   // int NotifiId = (int)((UIButton *)sender).tag;
    [self splitAccept:strNotificationId];
    [self.objSplitNotification removeFromParentViewController];
    [self.alertView close];
}

-(void) splitAccept:(int) NotifiId
{
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"notification_id":[NSString stringWithFormat:@"%d", NotifiId]
                                ,@"accepted":@"1"};
    [self.manager changeNotificationStatus:dicParams];
}

-(void) splitReject:(int) NotifiId
{
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"notification_id":[NSString stringWithFormat:@"%d", NotifiId]
                                ,@"accepted":@"2"};
    [self.manager changeNotificationStatus:dicParams];
}

-(void) DidChangeNotificationStatusSuccessfully:(RapidzzBaseManager *)manager
{
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == k_API_Success)
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
        [self.alertView close];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
    }
}

-(void) DidChangeNotificationStatusFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
    
}
















- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    NSString *usedSDK = [[NSString stringWithFormat:@"%@",url] substringToIndex:2];
    if ([usedSDK isEqualToString:@"fb"])
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url
                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else if ([usedSDK isEqualToString:@"co"])
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
}



// FOR iOS 8 and Older
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *usedSDK = [[NSString stringWithFormat:@"%@",url] substringToIndex:2];
    if ([usedSDK isEqualToString:@"fb"])
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    }
    
    
    
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
                              UIApplicationOpenURLOptionsAnnotationKey: annotation};
    return [self application:application
                     openURL:url
                     options:options];
    
}


-(void) signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rapidzz.Yourder" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Yourder" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Yourder.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
