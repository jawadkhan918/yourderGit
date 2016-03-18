//
//  YourorderViewController.m
//  Yourder
//
//  Created by Rapidzz on 12/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "YourorderViewController.h"

@interface YourorderViewController ()
{
    //float totalAmount;
    NSMutableArray *arrUserDishes;
    id removedDish;
    AppDelegate *delegate;
    
}

@end

@implementation YourorderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.totalAmount = 0.0;
    [self bindRestaurantInfo];
    [self getDishes];
}

#pragma mark - get Saved Dishes

-(void)getDishes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    arrUserDishes = [[NSMutableArray alloc] init];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    //NSLog(@"dict%@",[AppDelegate singleton].userInfo);
    NSDictionary *dict = @{@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                           ,@"status":@"0"};
    [self.manager getUserDishes:dict];
}

-(void)DidGetUserDishesSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //serviceResponse = manager.data;
    arrUserDishes = [NSMutableArray arrayWithArray:[manager.data objectForKey:@"order_detail"]];
    [AppDelegate singleton].arrCurrOrder = arrUserDishes;
    [self.tblOrder reloadData];
    for (int i = 0; i<arrUserDishes.count; i++)
    {
        self.totalAmount = self.totalAmount + [[[arrUserDishes objectAtIndex:i] objectForKey:@"uPay"] floatValue];
        self.lblTotalAmount.text = [NSString stringWithFormat:@"%.02f",self.totalAmount];
    }
    //[AppDelegate singleton].totalBillAmount = self.totalAmount; //[[manager.data objectForKey:@"total_price"] floatValue];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.totalBillAmount = delegate.totalBillAmount + self.totalAmount;
    

}

-(void)DidFailToGetUserDishes:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}


-(void) bindRestaurantInfo
{
    //RESTAURANT INFO BINDING
    self.lblRestName.text = [self.dictSelectedRestaurant objectForKey:@"rest_name"];
    NSURL *logoImageURL = [NSURL URLWithString:[self.dictSelectedRestaurant objectForKey:@"rest_logo"]];
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



-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return [AppDelegate singleton].arrCurrOrder.count;
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
    
    
    //int row =  (int)indexPath.row;
    NSDictionary *dict = [arrUserDishes objectAtIndex:indexPath.row];
    //cell.btnRemove.tag = row; //[[dict objectForKey:@"detail_id"] intValue];
    
    [cell.btnRemove addTarget:self action:@selector(removeFromCart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRemove setTag:(int)indexPath.row];
    cell.lblDishName.text = [dict objectForKey:@"item_name"];
    //cell.txtCount.text = [dict objectForKey:@"count"];
    //cell.lblDishPrice.text = [NSString stringWithFormat:@"%@ x $ %@",[dict objectForKey:@"quantity"],[dict objectForKey:@"item_price"]];
    if ([[dict objectForKey:@"splitwith"] count] <= 0)
    {
        cell.lblSplitWith.text = @"";
    }
    else
    {
        cell.lblSplitWith.text = [NSString stringWithFormat:@"split with %lu person",[[dict objectForKey:@"splitwith"] count]];
    }
    
    cell.lblYouPay.text =[NSString stringWithFormat:@"%.02f",[[dict objectForKey:@"uPay"] floatValue]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)placeOrder:(id)sender
{
    [self saveOrder];
}

// SAVE ORDER MASTER DETAIL
-(void) saveOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *dictParams = @{@"order_id":[NSString stringWithFormat:@"%d",[AppDelegate singleton].previousOrderId]
                             };

    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager PlaceOrderToKitchen:dictParams];
}

-(void) DidOrderPlacedToKitchenSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
    //[AppDelegate singleton].totalAmount = [self.lblTotalAmount.text floatValue];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.totalBillAmount = [[manager.data objectForKey:@"total_price"] floatValue];
}

-(void) DidOrderPlacedToKitchenFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}


#pragma mark - Remove Dish From Order

-(IBAction)removeFromCart:(id)sender
{
    UIButton *instanceButton = (UIButton*)sender;

    [self removeDish:[[[arrUserDishes objectAtIndex:instanceButton.tag] objectForKey:@"detail_id"] intValue]];
    removedDish = [arrUserDishes objectAtIndex:instanceButton.tag];
    NSLog(@"removed from cart");
}

// SAVE ORDER MASTER DETAIL
-(void) removeDish:(int) detail_id
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"detail_id":[NSString stringWithFormat:@"%d",detail_id]
                                 };
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager removeDishFromOrder:dictParams];
}

-(void) DidRemoveFromOrderSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
    
    // LOAD DISHESH AGAIN
    [arrUserDishes removeObject:removedDish];
    [self.tblOrder reloadData];
    if (arrUserDishes.count > 0)
    {
        for (int i = 0; i<arrUserDishes.count; i++)
        {
            self.totalAmount = self.totalAmount + [[[arrUserDishes objectAtIndex:i] objectForKey:@"uPay"] floatValue];
            self.lblTotalAmount.text = [NSString stringWithFormat:@"%.02f",self.totalAmount];
            //[self.btnCancel setTitle:self.lblTotalAmount.text forState:UIControlStateNormal];
        }
    }
    else
    {
        self.lblTotalAmount.text = @"00.00";
    }
    
}

-(void) DidRemoveFromOrderFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}



/*
#pragma mark SAVE ORDER
-(IBAction)placeOrder:(id)sender
{
    [self saveOrder];
}

// SAVE ORDER MASTER DETAIL
-(void) saveOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"rest_id":[[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_id"]
                                 ,@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                                 ,@"order_totalbill":self.lblTotalAmount.text
                                 ,@"order_status":@"0"
                                 ,@"barcode_value":[AppDelegate singleton].userTableBarcode
                                 };
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager saveOrder:dictParams];
}

-(void) didAddOrderSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *order_id = [manager.data objectForKey:@"order_id"];
    [self saveOrderDetail:order_id];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Order placed successfully"];
    [AppDelegate singleton].totalAmount = [self.lblTotalAmount.text floatValue];
}

-(void) didAddOrderFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


// SAVE ORDER DETAIL (DISHES DETAIL)
-(void) saveOrderDetail: (NSString *) orderID
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictDetail;
    for (int i = 0; i<[AppDelegate singleton].arrCurrOrder.count; i++)
    {
        dictDetail = [[AppDelegate singleton].arrCurrOrder objectAtIndex:i];
        NSDictionary *dictParams = @{@"order_id":orderID
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
        [self.manager addOrderDetail:dictParams];
    }
    
    if ([AppDelegate singleton].arrPlacedOrder.count > 0)
    {
        for (int i = 0; i<[AppDelegate singleton].arrCurrOrder.count; i++)
        {
            [[AppDelegate singleton].arrPlacedOrder addObject:[[AppDelegate singleton].arrCurrOrder objectAtIndex:i]];
        }
    }
    else
    {
        [AppDelegate singleton].arrPlacedOrder = [[NSMutableArray alloc] initWithArray:(NSArray *)[AppDelegate singleton].arrCurrOrder];
    }
    [[AppDelegate singleton].arrCurrOrder removeAllObjects];
    
}

-(void) didAddOrderDetailSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[self.manager.data objectForKey:@"status"] intValue] == 0)
    {
        //[AppDelegate singleton].arrPlacedOrder = [AppDelegate singleton].arrCurrOrder;
        
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
    }
}

-(void) didAddOrderDetailFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
*/

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
