//
//  pagerChildViewController.m
//  Yourder
//
//  Created by Rapidzz on 07/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "pagerChildViewController.h"

@interface pagerChildViewController ()
{
    NSMutableDictionary *tempDict;
    UIView *serviceView;
    UIView *emptyView;
}


@end
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@implementation pagerChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDishesByCatId];
    NSLog(@"index is : %lu", (long)self.index);
    
    //self.view.backgroundColor = [UIColor greenColor];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        self.tblDishes.frame = CGRectMake(0, 0, 320, 400);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        self.tblDishes.frame = CGRectMake(0, 0, 375, 400);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        self.tblDishes.frame = CGRectMake(0, 0, 414, 400);
    } else if ([[UIScreen mainScreen] bounds].size.height == 1024)
    {
        self.tblDishes.frame = CGRectMake(0,0, self.view.frame.size.width,850);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GET DISHES BY CATEGORY

-(void) getDishesByCatId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"cat_id":[AppDelegate singleton].selectedCatId};
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager getDishesByCatID:dictParams];
}

-(void) didGetDishesByCategorySuccessfully:(RapidzzBaseManager *)manager
{
    self.arrMenuItems = [manager.data objectForKey:@"data"];
    self.tblDishes.delegate = self;
    self.tblDishes.dataSource = self;
    [self.tblDishes reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) didGetDishesByCategoryFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    DishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  
    
    if (cell == nil)
    {
        cell = [[DishesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
    }
    
    int index = (int)indexPath.row;
    
    NSDictionary *dict = [self.arrMenuItems objectAtIndex:indexPath.row];
    cell.lblDishName.text = [dict objectForKey:@"item_name"];
    cell.lblDishDetail.text = [dict objectForKey:@"item_decription"];
    cell.lblDishPrice.text = [NSString stringWithFormat:@"$ %@",[dict objectForKey:@"item_price"]];
    cell.btnAdd.tag = index; //[[dict objectForKey:@"items_id"] intValue];
    
    //[cell.btnAdd addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAdd addTarget:self action:@selector(showYourderPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[dict objectForKey:@"item_thumbnail"] length] > 10)
    {
        NSURL *agentImageURL = [NSURL URLWithString:[dict objectForKey:@"item_thumbnail"]];
        [cell.imgDishthumb setImageWithURL:agentImageURL];
    }
    else
    {
        cell.imgDishthumb.image = [UIImage imageNamed:@"no-image-yourder.png"];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    dictSelectedRestaurant = [self.arrRestaurants objectAtIndex:indexPath.row];
    //    [self performSegueWithIdentifier:@"RestaurantlistingToDetail" sender:self];
}


#pragma mark - SPLIT POPUP

- (IBAction)showYourderPopup:(id)sender
{

    // Here we need to pass a full frame
    self.alertView = [[CustomIOSAlertView alloc] init];
    self.alertView.tag = 1001;
    UIButton *btnClicked = (UIButton *)sender;
    int index = (int)btnClicked.tag;
    // Add some custom content to the alert view
    [self.alertView setContainerView:[self createPopup:index]];
    
    // Modify the parameters
    [self.alertView setButtonTitles:nil];
    //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", nil]];
    [self.alertView setDelegate:self];
    
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
}

- (UIView *) createPopup: (int) index
{
    UIView *demoView ;
    
    _objYourderView = [[[NSBundle mainBundle] loadNibNamed:@"Yourderpopup" owner:self options:nil] objectAtIndex:0];
    _objYourderView.tag = 1001;
    
    if ( IDIOM == IPAD ) {
        
        demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
        _objYourderView.frame = CGRectMake(0, 0, 360, 480);
        
    } else {
        demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 302, 430)];
        _objYourderView.frame = CGRectMake(0, 0, 302, 430);
        
    }
    _objYourderView.layer.cornerRadius = 7;
    _objYourderView.layer.masksToBounds = YES;
    _objYourderView.arrMenuItems = self.arrMenuItems;
    _objYourderView.selectedDishIndex = index;
    [_objYourderView bindDishInfo];
    [_objYourderView getTableUsers];
    
     //ADD BUTTONS METHODS
     [_objYourderView.btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
     [_objYourderView.btnDone addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    
    [demoView addSubview:_objYourderView];
    return demoView;
}


-(IBAction)btnCancel:(id)sender
{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.alertView close];
}

-(IBAction)btnDone:(id)sender
{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.alertView close];
    
    //[self saveOrder];
}


-(IBAction)addToCart:(id)sender
{
    [MBProgressHUD showHUDAddedTo:_objYourderView animated:YES];
    // GHAFAR CODE TO CLEAR SELECTED
    [AppDelegate singleton].strUsersId = @"";
    for(int i=0;i<[AppDelegate singleton].arrPersons.count;i++)
    {
        if(![[AppDelegate singleton].strUsersId isEqualToString:@""])
        {
            [AppDelegate singleton].strUsersId = [[AppDelegate singleton].strUsersId stringByAppendingString:@","];
        }
        
        [AppDelegate singleton].strUsersId = [[AppDelegate singleton].strUsersId stringByAppendingString:[[[AppDelegate singleton].arrPersons objectAtIndex:i]objectForKey:@"login_id"]];
    }
    
    //NSDictionary *dict = [self.arrMenuItems objectAtIndex:[AppDelegate singleton].addedDishIndex];
    tempDict = [[NSMutableDictionary alloc] initWithDictionary:[self.arrMenuItems objectAtIndex:[AppDelegate singleton].addedDishIndex]];
    [tempDict setObject:_objYourderView.txtQuantity.text forKey:@"quantity"];
    [tempDict setObject:_objYourderView.txtComments.text forKey:@"comments"];
    if ([AppDelegate singleton].strUsersId.length > 0)
    {
        [tempDict setObject:[AppDelegate singleton].strUsersId forKey:@"splitwith"];
    }
    else
    {
        [tempDict setObject:@"" forKey:@"splitwith"];
    }
    
    //SEND DISH TO DB
    [self saveOrder:tempDict];
     
}


// SAVE ORDER MASTER DETAIL
-(void) saveOrder: (NSDictionary *)dictDetail
{
    
//    int orderId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"order_id"] intValue];
//    if (orderId == 0)
//    {
//        orderId = 0;
//    }
    
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"rest_id":[[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_id"]
                                 ,@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                                 //,@"order_totalbill":self.lblTotalAmount.text
                                 ,@"order_status":@"0"
                                 ,@"barcode_value":[AppDelegate singleton].userTableBarcode
                                 ,@"order_id":[NSString stringWithFormat:@"%d",[AppDelegate singleton].previousOrderId]
                                 ,@"cat_id":[dictDetail objectForKey:@"cat_id"]
                                 ,@"dish_id":[dictDetail objectForKey:@"items_id"]
                                 ,@"detail_quantity":[dictDetail objectForKey:@"quantity"]
                                 ,@"detail_status":@"0"
                                 ,@"detail_datetime":@"01-01-2016 00:00:00"
                                 ,@"comments":[dictDetail objectForKey:@"comments"]
                                 ,@"splitwith":[dictDetail objectForKey:@"splitwith"]
                                 };
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager saveOrder:dictParams];
}

-(void) didAddOrderSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:_objYourderView animated:YES];
    //[[NSUserDefaults standardUserDefaults]setObject:order_id forKey:@"order_id"];
    [AppDelegate singleton].previousOrderId = [[manager.data objectForKey:@"order_id"] intValue];
    
    
    //SEND NOTIFICATION TO SPLIT USERS
    [self sendPushNotification:[manager.data objectForKey:@"data"]];
    
    //CLOSE SCREEN
    [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.alertView close];
    
    //[AppDelegate singleton].totalAmount = [self.lblTotalAmount.text floatValue];
}

-(void) didAddOrderFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:_objYourderView animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}

//SEND SPLIT NOTIFICATION TO USER
-(void) sendPushNotification: (NSArray *) arrUsersForNotifications
{
    for (int i = 0; i<arrUsersForNotifications.count; i++)
    {
        NSDictionary *data = @{
                               @"notification_id" : [[arrUsersForNotifications objectAtIndex:i] objectForKey:@"notification_id"],
                               @"login_name" : [[AppDelegate singleton].userInfo objectForKey:@"login_name"],
                               @"receiver_email" : [[arrUsersForNotifications objectAtIndex:i] objectForKey:@"login_email"],
                               @"login_id" : [[AppDelegate singleton].userInfo objectForKey:@"login_id"],
                               @"profile_picture" : [[AppDelegate singleton].userInfo objectForKey:@"profile_picture"],
                               @"badge" : @"Increment",
                               @"item_name" : [tempDict objectForKey:@"item_name"],
                               @"content-available" : @"1",
                               @"alert":[NSString stringWithFormat:@"%@ want to split %@ with you",[[AppDelegate singleton].userInfo objectForKey:@"login_name"],[tempDict objectForKey:@"item_name"]]
                               };
        
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"email" equalTo:[data objectForKey:@"receiver_email"]];
        
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // This line for send to specific user
        
        [push setData:data];
        [push sendPushInBackground];

    }
    
    //[push setChannels:@[ @"Mets" ]];
    //[push setData:data];
    //[push sendPushInBackground];
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
