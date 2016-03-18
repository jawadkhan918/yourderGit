//
//  AppDelegate.h
//  Yourder
//
//  Created by Rapidzz on 15/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn.h>
#import <Parse/Parse.h>
#import "CustomIOSAlertView.h"
#import "SplitNotificationPopupVC.h"
#import "UIImageView+WebCache.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, CustomIOSAlertViewDelegate, RapidzzUserManagerDelegate>
{
    UIAlertView *alert;
}

@property (strong, nonatomic) RapidzzUserManager *manager;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSArray *arrCurrOrder;
@property (strong, nonatomic) NSMutableArray *arrPlacedOrder;
@property (strong, nonatomic) NSString *strUsersId;
@property (strong, nonatomic) NSMutableArray *arrPersons;
@property (strong, nonatomic) NSString *selectedCatId;
@property (strong, nonatomic) NSString *userTableBarcode;
@property (strong, nonatomic) NSDictionary *dictSelectedRestaurant;
@property (strong, nonatomic) NSDictionary *dictLogedInRestaurantInfo;
@property (strong, nonatomic) NSDictionary *dictUserPreviousOrderDetail;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSString *Rest_key;
@property (strong, nonatomic) NSString *User_id;
@property (strong, nonatomic) NSString *Waiter_Name;
@property (strong ,nonatomic) NSMutableArray *arrSelectedTabels;



@property float totalAmount;
@property (readwrite) float totalBillAmount;
@property int previousOrderId;
@property int loginType;



//SPLIT NOTIFICATION POPUP
@property (strong, nonatomic) SplitNotificationPopupVC *objSplitNotification;
@property (nonatomic,strong) CustomIOSAlertView *alertView;
@property NSInteger addedDishIndex;



-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;
+(AppDelegate*)singleton;
-(void)showAlertwith:(NSString*)Title andMessage:(NSString*)Messsage;
-(void)showHudMessage:(NSString*)message;
- (IBAction)SplitNotification:(id)sender;
-(IBAction)btnDone:(id)sender;
-(IBAction)btnCancel:(id)sender;



@end

