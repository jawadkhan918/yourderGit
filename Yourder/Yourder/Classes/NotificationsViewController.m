//
//  NotificationsViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 23/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //SLIDEBAR VIEW
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self getNotifications];
}

-(void) viewWillAppear:(BOOL)animated
{
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
}



-(void) getNotifications
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.arrNotifications = [[NSMutableArray alloc] init];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSDictionary *dicParams = @{@"user_id":[dict objectForKey:@"login_id"]
                                };
    [self.manager getUserNotifications:dicParams];
    
    
}


-(void) DidGetNotificationByUserIdSuccessfull:(RapidzzBaseManager *)manager
{
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
        self.arrNotifications = [self.manager.data objectForKey:@"data"];
    else
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];

    [self.tblNotifications reloadData];
    //self.arrOrderHistory = self.manager.data;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void) DidGetNotificationByUserIdFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:[NSString stringWithFormat:@"%@",error]];

}
# pragma mark - TABLE DELEGATES

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    
    //int index = (int)indexPath.row;
    NSDictionary *dict = [self.arrNotifications objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = [dict objectForKey:@"title"];
    cell.lblMessage.text = [dict objectForKey:@"message"];
    cell.lblDateTime.text = [dict objectForKey:@"notification_date"];
    cell.lblSender.text = [NSString stringWithFormat:@"send by %@",[dict objectForKey:@"user_name"]];
    
    if ([[dict objectForKey:@"profile_picture"] length] < 10)
    {
        cell.imgUser.image = [UIImage imageNamed:@"icon-person-notification.png"];
    }
    else
    {
        NSURL *logoImageURL = [NSURL URLWithString:[dict objectForKey:@"profile_picture"]];
        [cell.imgUser setImageWithURL:logoImageURL];
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2;
        cell.imgUser.layer.masksToBounds = YES;
        cell.imgUser.clipsToBounds = YES;
    }
    cell.btn_order.tag = indexPath.row+1;
    cell.btn_decline.tag = indexPath.row+1;
    [cell.btn_order addTarget:self action:@selector(Order:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_decline addTarget:self action:@selector(Decline:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}



/*-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictNotifiData = [self.arrNotifications objectAtIndex:indexPath.row];
    
    NSDictionary *data = @{
                           @"notification_id" : [dictNotifiData objectForKey:@"notification_id"],
                           @"login_name" : [dictNotifiData objectForKey:@"user_name"],
                           @"login_id" : [[AppDelegate singleton].userInfo objectForKey:@"login_id"],
                           @"profile_picture" : [dictNotifiData objectForKey:@"profile_picture"],
                           @"item_name" : [dictNotifiData objectForKey:@"items_name"],
                           @"content-available" : @"1"
                           };
    //[self sendPushNotification:data];
    
    

    [[AppDelegate singleton] SplitNotification:data];
}*/
-(IBAction)Order:(id)sender{
    
    UIButton *instanceButton = (UIButton*)sender;

     NSString *str = @"Order";
    NSDictionary *dictNotifiData = [self.arrNotifications objectAtIndex:instanceButton.tag-1];
    
    NSDictionary *data = @{
                           @"notification_id" : [dictNotifiData objectForKey:@"notification_id"],
                           @"login_name" : [dictNotifiData objectForKey:@"user_name"],
                           @"login_id" : [[AppDelegate singleton].userInfo objectForKey:@"login_id"],
                           @"profile_picture" : [dictNotifiData objectForKey:@"profile_picture"],
                           @"item_name" : [dictNotifiData objectForKey:@"items_name"],
                           @"content-available" : @"1",
                           @"buttonTitle":str
                           };
    //[self sendPushNotification:data];
    
    
    
    [[AppDelegate singleton] btnDone:data];

    [self performSelector:@selector(getNotifications) withObject:self afterDelay:3.0 ];
    
    
}



-(IBAction)Decline:(id)sender{
    
    UIButton *instanceButton = (UIButton*)sender;
    
    
    NSDictionary *dictNotifiData = [self.arrNotifications objectAtIndex:instanceButton.tag-1];
    NSString *str = @"Decline";
    
    NSDictionary *data = @{
                           @"notification_id" : [dictNotifiData objectForKey:@"notification_id"],
                           @"login_name" : [dictNotifiData objectForKey:@"user_name"],
                           @"login_id" : [[AppDelegate singleton].userInfo objectForKey:@"login_id"],
                           @"profile_picture" : [dictNotifiData objectForKey:@"profile_picture"],
                           @"item_name" : [dictNotifiData objectForKey:@"items_name"],
                           @"content-available" : @"1",
                           @"buttonTitle":str
                           };
    //[self sendPushNotification:data];
    
    
    
    [[AppDelegate singleton] btnCancel:data];
     [self performSelector:@selector(getNotifications) withObject:self afterDelay:3.0 ];
    
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
