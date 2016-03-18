//
//  SplitDetailPopVC.m
//  Yourder
//
//  Created by Arslan Ilyas on 26/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "SplitDetailPopVC.h"


@interface SplitDetailPopVC ()

@end

@implementation SplitDetailPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.self.
    self.arrUsers = [[NSMutableArray alloc]init];
    self.arrUsers = [self.dictDishDetail objectForKey:@"splitwith"];
    self.lblDishName.text = [self.dictDishDetail objectForKey:@"item_name"];
    
    [self getSplitedInfo];
}


-(void)getSplitedInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    NSDictionary *dic = @{@"detail_id":[self.dictDishDetail objectForKey:@"detail_id"],
                          @"barcode_value":[AppDelegate singleton].userTableBarcode,
                          @"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"],
                          };
    [self.manager getDishSplitedInfo:dic];
}

-(void)DidGetDishSplitedInfoSuccessfully:(RapidzzBaseManager *)manager
{
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        self.arrUsers = [self.manager.data objectForKey:@"data"];
        [self.tblUsers reloadData];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //self.arrOrderHistory = self.manager.data;
    
}
-(void)DidFailToGetDishSplitedInfo:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    
}



# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"cell";
    SplitDetailPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil)
    {
        cell = [[SplitDetailPopupCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    cell.lblUsername.text = @"Ghafar";
    cell.lblUsername.text = [[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"login_name"];
    
    if ([[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"accepted"] intValue] == k_Notification_Status_Pending)
    {
        cell.lblAcceptStatus.text = @"Waiting";
    }
    else if ([[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"accepted"] intValue] == k_Notification_Status_Accept)
    {
        cell.lblAcceptStatus.text = @"Accepted";
    }
    else if ([[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"accepted"] intValue] == k_Notification_Status_Reject)
    {
        cell.lblAcceptStatus.text = @"Rejected";
    }
    else if ([[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"accepted"] intValue] == k_Notification_Status_Notsend)
    {
        cell.lblAcceptStatus.text = @"";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(220, 15, 50, 26);
        [button addTarget:self action:@selector(sendSplitNotification:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"SEND" forState:UIControlStateNormal];
        UIImage *btnImage = [UIImage imageNamed:@"btn-red.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
        button.tag = indexPath.row;
        
        
        UILabel *lblItemCount = [[UILabel alloc] init];
        [lblItemCount setFrame:CGRectMake(220, 15, 50, 26)];
        lblItemCount.text = @"SEND";
        lblItemCount.textAlignment = NSTextAlignmentCenter;
        lblItemCount.textColor = [UIColor whiteColor];
        [lblItemCount setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        
        [cell addSubview:button];
        [cell addSubview:lblItemCount];
    }
    
    if ([[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"profile_picture"] length] < 10)
    {
        //cell.imageView.image = [UIImage imageNamed:@"icon-person-notification.png"];
        cell.imgUser.image = [UIImage imageNamed:@"icon-person-notification.png"];
    }
    else
    {
        NSURL *agentImageURL = [NSURL URLWithString:[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"profile_picture"]];
        [cell.imgUser setImageWithURL:agentImageURL];
        cell.imgUser.layer.cornerRadius=20;
        cell.imgUser.layer.masksToBounds = YES;
    }
    
    
    //    if(indexPath.row % 2 == 0)
    //        cell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f];
    //    //cell.backgroundColor = [UIColor lightGrayColor];
    //
    //    else
    //        cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
    
}
-(IBAction)sendSplitNotification:(id)sender
{
    NSString *receiverId = [[self.arrUsers objectAtIndex:(int)((UIButton *)sender).tag] objectForKey:@"login_id"];
    
    [self sendNotification:receiverId];
    NSLog(@"split sended");
    
}


-(void) sendNotification:(NSString *) receiverId
{
    //SEND NOTIFICATION TO ALL
    
    NSMutableArray *arrSplit = [[NSMutableArray alloc] init];
    NSDictionary *dictSplitIds = @{@"id":receiverId};
    [arrSplit addObject:dictSplitIds];
    
    NSError *error;
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrSplit options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    //SAVE IN DB
    NSArray *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData2 options:0 error:&error];
    NSLog(@"%@", dataDictionary);
    NSDictionary *dictParams = @{@"items_id":[NSString stringWithFormat:@"%@",[self.dictDishDetail objectForKey:@"items_id"]]
                                 ,@"sender_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                                 ,@"receiver_id":[[dataDictionary objectAtIndex:0] objectForKey:@"id"]
                                 ,@"message":[NSString stringWithFormat:@"%@ want to split %@ with you",[[AppDelegate singleton].userInfo objectForKey:@"login_name"],[self.dictDishDetail objectForKey:@"item_name"]],
                                 @"detail_id":[self.dictDishDetail objectForKey:@"detail_id"]};
    
    [self sendSplitNotificationToDB:dictParams];
    
}

#pragma mark SPLIT NOTIFICATION

-(void) sendSplitNotificationToDB:(id) dict
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager sendNotification:dict];
}

-(void) DidNotificationSentSuccessfully:(RapidzzBaseManager *)manager
{
    
    NSLog(@"Send push notification");
    //[tempDict setObject:[manager.data objectForKey:@"notification_id"] forKey:@"notification_id"];
    NSArray *arrResult = [manager.data objectForKey:@"data"];
    
    for (int i = 0; i<arrResult.count; i++)
    {
        NSDictionary *data = @{
                               @"notification_id" : [[arrResult objectAtIndex:i] objectForKey:@"notification_id"],
                               @"login_name" : [[AppDelegate singleton].userInfo objectForKey:@"login_name"],
                               @"receiver_email" : [[arrResult objectAtIndex:i] objectForKey:@"receiver_email"],
                               @"login_id" : [[AppDelegate singleton].userInfo objectForKey:@"login_id"],
                               @"profile_picture" : [[AppDelegate singleton].userInfo objectForKey:@"profile_picture"],
                               @"badge" : @"Increment",
                               @"item_name" : [self.dictDishDetail objectForKey:@"item_name"],
                               @"content-available" : @"1",
                               @"alert":[NSString stringWithFormat:@"%@ want to split %@ with you",[[AppDelegate singleton].userInfo objectForKey:@"login_name"],[self.dictDishDetail objectForKey:@"item_name"]]
                               };
        [self sendPushNotification:data];
        [self btnCancel:self];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) DidNotificationSentFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//SEND SPLIT NOTIFICATION TO USER
-(void) sendPushNotification: (NSDictionary *) dict
{
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"email" equalTo:[dict objectForKey:@"receiver_email"]];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // This line for send to specific user
    
    [push setData:dict];
    [push sendPushInBackground];
    
    
    //[push setChannels:@[ @"Mets" ]];
    //[push setData:data];
    //[push sendPushInBackground];
}






-(IBAction)btnCancel:(id)sender
{
    //[[self.view viewWithTag:1001] removeFromSuperview];
    //[[AppDelegate singleton].arrCurrOrder removeAllObjects];
    [[AppDelegate singleton].alertView close];
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
