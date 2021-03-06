//
//  UserOrderViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 11/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "UserOrderViewController.h"
#import "UserOrderTableViewCell.h"
#import "serviceRCell.h"

@interface UserOrderViewController ()
{
    BOOL isServed;
    NSArray *arrServedOrder;
    NSMutableArray *arrServedDishes;
    NSMutableArray *arrSelectDishes;
    NSString *strOrderId;
    NSDictionary *dictUserDishes;
   NSString *strSelectedDishes;
    UserOrderTableViewCell *currentCell;
    NSArray *removedDish;
}

@end

@implementation UserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrServedOrder = [[NSMutableArray alloc]init];
    self.arrServedOrder = [[NSMutableArray alloc]init];
    arrSelectDishes = [[NSMutableArray alloc]init];
    removedDish = [[NSArray alloc]init];
    
    self.userName.text = [self.dictSelectedUserInfo objectForKey:@"login_name"];
     NSURL *logoImageURL = [NSURL URLWithString:[self.dictSelectedUserInfo objectForKey:@"profile_picture"]];
    self.user_img.layer.cornerRadius = self.user_img.frame.size.height/2;
    self.user_img.layer.masksToBounds = YES;
    self.user_img.layer.borderWidth = 0;
    [self.user_img setImageWithURL:logoImageURL];
    
    if ([[self.dictSelectedUserInfo objectForKey:@"profile_picture"] length] < 10)
    {
        self.user_img.image = [UIImage imageNamed:@"icon-person-notification.png"];
    }
    
    
    self.slider_btn.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slider_btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.lblOrdered.hidden = NO;
    self.lblServed.hidden = YES;
    
    isServed = NO;
    
    [self getDishes];
    
}

#pragma mark - serve Order

-(void)serveOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    //NSLog(@"dict%@",[AppDelegate singleton].userInfo);
    NSDictionary *dict = @{@"detail_id":strSelectedDishes};
   [self.manager orderServed:dict];
}

-(void)DidOrderServedSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //serviceResponse = manager.data;
     self.arrUserDishes = [[NSMutableArray alloc] init];
    NSDictionary *dict = manager.data;
    if([[dict objectForKey:@"status"] integerValue] == 0)
    {
        self.lblServed.hidden = NO;
        self.lblOrdered.hidden = YES;
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
        [self getDishes];
    }
}
-(void)DidFailToOrderServed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}

#pragma mark - get served Orders

-(void)getServedOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    //NSLog(@"dict%@",[AppDelegate singleton].userInfo);
    NSDictionary *dict = @{@"order_id":[self.dictSelectedUserInfo objectForKey:@"login_id"]};
    [self.manager getServedOrders:dict];
}

-(void)DidGetServedOrdersSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //serviceResponse = manager.data;
    self.arrUserDishes = [[NSMutableArray alloc] init];
    if([manager.data objectForKey:@"status"] == 0)
    {
        self.arrUserDishes = [manager.data objectForKey:@"data"];
        [self.Table reloadData];

    }
    
}
-(void)DidFailToGetServedOrders:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}



#pragma mark - get Saved Dishes

-(void)getDishes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   self.arrUserDishes = [[NSMutableArray alloc] init];
    self.arrServedOrder = [[NSMutableArray alloc]init];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    //NSLog(@"dict%@",[AppDelegate singleton].userInfo);
    NSString *User_id = [self.dictSelectedUserInfo objectForKey:@"login_id"];
    NSDictionary *dict = @{@"login_id":User_id
                           ,@"status":@"1"};
    [self.manager getUserDishes:dict];
    
    
}

-(void)DidGetUserDishesSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //serviceResponse = manager.data;
    dictUserDishes = manager.data;
    arrServedDishes = [dictUserDishes objectForKey:@"order_detail"];
   
    for(int i =0;i<arrServedDishes.count;i++)
    {
        if([[[arrServedDishes objectAtIndex:i]objectForKey:@"served_order"] integerValue] == 0)
        {
            [self.arrUserDishes addObject:[arrServedDishes objectAtIndex:i]];
        }
        else
        {
            [self.arrServedOrder addObject:[arrServedDishes objectAtIndex:i]];
        }
    }
    
    
    [AppDelegate singleton].arrCurrOrder = [dictUserDishes objectForKey:@"order_detail"];
    [self.Table reloadData];
  
    
}

-(void)DidFailToGetUserDishes:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isServed)
    {
        return self.arrUserDishes.count;
    }
    else
    {
        return self.arrServedOrder.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserOrderTableViewCell   *cell;
    
    static NSString *MyIdentifier = @"orderCell";
    cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
   // cell.accessoryType = UITableViewCellAccessoryNone;

    if (cell == nil)
    {
        cell = [[UserOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:MyIdentifier];
    }

    if(isServed == YES)
    {
        
        cell.order_name.text = [[self.arrUserDishes objectAtIndex:indexPath.row]objectForKey:@"item_name"];
        cell.des_name.text= [[self.arrUserDishes objectAtIndex:indexPath.row]objectForKey:@"comment"];
        [cell.count_img setTitle:[[self.arrUserDishes objectAtIndex:indexPath.row]objectForKey:@"detail_quantity"] forState:UIControlStateNormal];
        cell.count_img.layer.cornerRadius = cell.count_img.frame.size.height/2;
        cell.count_img.layer.masksToBounds = YES;
        cell.count_img.layer.borderWidth = 0;
        [cell.count_img setBackgroundColor:[UIColor colorWithRed:188/255.0 green:0/255.0 blue:8/255.0 alpha:1]];
        cell.btnDelete.hidden = YES;
        cell.btnServed.hidden = YES;
        cell.imgDelete.hidden = YES;
        cell.imgServed.hidden = YES;
        
    }
    else
    {
        
        cell.order_name.text = [[self.arrServedOrder objectAtIndex:indexPath.row]objectForKey:@"item_name"];
        cell.des_name.text= [[self.arrServedOrder objectAtIndex:indexPath.row]objectForKey:@"comment"];
        [cell.count_img setTitle:[[self.arrServedOrder objectAtIndex:indexPath.row]objectForKey:@"detail_quantity"] forState:UIControlStateNormal];
        cell.count_img.layer.cornerRadius = cell.count_img.frame.size.height/2;
        cell.count_img.layer.masksToBounds = YES;
        cell.count_img.layer.borderWidth = 0;
        [cell.count_img setBackgroundColor:[UIColor colorWithRed:188/255.0 green:0/255.0 blue:8/255.0 alpha:1]];
        cell.btnDelete.hidden = NO;
        cell.btnServed.hidden = NO;
        cell.imgDelete.hidden = NO;
        cell.imgServed.hidden = NO;

        
    }
    cell.btnServed.tag = (int)indexPath.row;
    cell.btnDelete.tag = (int)indexPath.row;

    
    
    
//    if (indexPath.section == 0)
//    {
//        static NSString *MyIdentifier = @"orderCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//        
//        if (cell == nil)
//        {
//            cell = [[UserOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                 reuseIdentifier:MyIdentifier];
//        }
//        if(isServed == YES)
//        {
//          
//                cell.order_name.text = [[self.arrUserDishes objectAtIndex:indexPath.row]objectForKey:@"item_name"];
//                cell.des_name.text= [[self.arrUserDishes objectAtIndex:indexPath.row]objectForKey:@"comment"];
//                [cell.count_img setTitle:[[self.arrUserDishes objectAtIndex:indexPath.row]objectForKey:@"detail_quantity"] forState:UIControlStateNormal];
//                cell.count_img.layer.cornerRadius = cell.count_img.frame.size.height/2;
//                cell.count_img.layer.masksToBounds = YES;
//                cell.count_img.layer.borderWidth = 0;
//                [cell.count_img setBackgroundColor:[UIColor colorWithRed:188/255.0 green:0/255.0 blue:8/255.0 alpha:1]];
//            
//        }
//        else
//        {
//            
//                cell.order_name.text = [[self.arrServedOrder objectAtIndex:indexPath.row]objectForKey:@"item_name"];
//                cell.des_name.text= [[self.arrServedOrder objectAtIndex:indexPath.row]objectForKey:@"comment"];
//                [cell.count_img setTitle:[[self.arrServedOrder objectAtIndex:indexPath.row]objectForKey:@"detail_quantity"] forState:UIControlStateNormal];
//                cell.count_img.layer.cornerRadius = cell.count_img.frame.size.height/2;
//                cell.count_img.layer.masksToBounds = YES;
//                cell.count_img.layer.borderWidth = 0;
//                [cell.count_img setBackgroundColor:[UIColor colorWithRed:188/255.0 green:0/255.0 blue:8/255.0 alpha:1]];
//                
//           // }
//        }
//        return cell;
//    }
//    if(indexPath.section == 1)
//    {
//        static NSString *MyIdentifier = @"serCell";
//       serviceRCell   *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//        
//        if (cell == nil)
//        {
//            cell = [[serviceRCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                 reuseIdentifier:MyIdentifier];
//        }
//        cell.lbl_service.text = @"";
//    
//         return cell;
//   
//    }
//    
    return cell;
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
//    
//    
//    if(cell.accessoryType == UITableViewCellAccessoryNone)
//    {
//        [arrSelectDishes addObject:[arrServedDishes objectAtIndex:indexPath.row]];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        [arrSelectDishes removeObject:[arrServedDishes objectAtIndex:indexPath.row]];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
    
}


-(IBAction)served:(id)sender
{
     UIButton *button = (UIButton *)sender;
    [arrSelectDishes addObject:[self.arrServedOrder objectAtIndex:(int)button.tag]];
    strSelectedDishes= @"";
    for(int i = 0;i<arrSelectDishes.count;i++)
    {
        if(![strSelectedDishes isEqualToString:@""])
        {
            strSelectedDishes = [strSelectedDishes stringByAppendingString:@","];
        }
        
        strSelectedDishes = [strSelectedDishes stringByAppendingString:[[arrSelectDishes objectAtIndex:i]objectForKey:@"detail_id"]];
        
    }
    
    
    isServed = YES;
    strOrderId = [dictUserDishes objectForKey:@"order_id"];
    [self serveOrder];
//    self.lblServed.hidden = NO;
//    self.lblOrdered.hidden = YES;
}

-(IBAction)clickOnOrdered:(id)sender
{
    isServed = NO;
    self.lblServed.hidden = YES;
    self.lblOrdered.hidden = NO;
    [self getDishes];
    //[self.Table reloadData];
    
}

-(IBAction)clickOnServed:(id)sender
{
    isServed = YES;
    self.lblServed.hidden = NO;
    self.lblOrdered.hidden = YES;
    [self getDishes];
    //[self.Table reloadData];
}

#pragma mark - Remove Dish From Order

-(IBAction)removeFromCart:(id)sender
{
    UIButton *instanceButton = (UIButton*)sender;
    
    [self removeDish:[[[self.arrServedOrder objectAtIndex:(int)instanceButton.tag] objectForKey:@"detail_id"] intValue]];
    removedDish = [self.arrServedOrder objectAtIndex:instanceButton.tag];
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
    
    // LOAD DISHESH AGAIN
    if([[manager.data objectForKey:@"status"]integerValue ] == 0)
    {
        [self.arrServedOrder removeObject:removedDish];
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
        [self.Table reloadData];
    }
   
}

-(void) DidRemoveFromOrderFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}





// SET HEADER TITLE AND BG COLORS
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return @"ORDERS";
//    if (section == 1)
//        return @"SERVICE REQUEST";
//    return @"undefined";
//}
//
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    if (section == 0)
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
//        label.text = @"ORDERS";
//        label.textColor = [UIColor darkGrayColor];
//        label.backgroundColor = [UIColor clearColor];
//        [label setFont:[UIFont systemFontOfSize:13]];
//        [headerView addSubview:label];
//    }
//    else
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
//        label.text = @"SERVICE REQUEST";
//        label.textColor = [UIColor darkGrayColor];
//        label.backgroundColor = [UIColor clearColor];
//         [label setFont:[UIFont systemFontOfSize:13]];
//        [headerView addSubview:label];
//    }
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    return headerView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 61.0;
}



-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
