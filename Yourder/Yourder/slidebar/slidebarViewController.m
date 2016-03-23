//
//  slidebarViewController.m
//  iSend2U
//
//  Created by Ghafar Tanveer on 20/11/2015.
//  Copyright (c) 2015 Ghafar Tanveer. All rights reserved.
//

#import "slidebarViewController.h"
#import "UIImageView+WebCache.h"
#import "sideMenuTableViewCell.h"

@interface slidebarViewController ()
{
    NSArray *menuItems;
    NSArray *arrImageIcons;
    NSDictionary *dicUserInfo;

}

@end

@implementation slidebarViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([AppDelegate singleton].loginType == k_Slide_Menu_RestaurantLogin)
    {
        menuItems = [NSArray arrayWithObjects:@"Home",@"Tables",@"Orders",@"Notifications",@"Settings",@"Logout", nil];
        //arrImageIcons = [NSArray arrayWithObjects:@"icon-home.png",@"Tables",@"Orders",@"Notifications",@"Settings",@"Logout", nil];
    }
    
    else
    {
        menuItems = [NSArray arrayWithObjects:@"Profile",@"Home", @"Payment", @"Settings",@"History",@"Notifications", @"Logout", nil];
        
        arrImageIcons = [NSArray arrayWithObjects:@"Profile", @"icon-home",@"icon-payment",@"icon-settings",@"icon-history",@"icon-loyalty",@"icon-logout", nil];
    }
    
    dicUserInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    self.tblMenu.scrollEnabled = NO;


}


- (void)viewWillAppear:(BOOL)animated
{
    if ([AppDelegate singleton].loginType == k_Slide_Menu_RestaurantLogin)
        menuItems = [NSArray arrayWithObjects:@"Profile",@"Home",@"Tables",@"Orders",@"Notifications",@"Settings",@"Logout", nil];
    else
        menuItems = [NSArray arrayWithObjects:@"Profile",@"Home", @"Payment", @"Settings",@"History",@"Notifications", @"Logout", nil];
    dicUserInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    [self.tblMenu reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0)
    {
        return 145;
    }
    else
    {
        return 58;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    sideMenuTableViewCell *cell;
    
    if ([AppDelegate singleton].loginType == k_Slide_Menu_UserLogin)
    {
        // USER MENU BINDING
        if(dicUserInfo!= nil)
        {
            if (indexPath.row == 0)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Profile" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-sideMenu-top.png"]];
                cell.lblUserName.text = [dicUserInfo objectForKey:@"login_name"];
                NSURL *userProfileImage = [NSURL URLWithString:[dicUserInfo objectForKey:@"profile_picture"]];
                [cell.profileImage setImageWithURL:userProfileImage];
                cell.profileImage.layer.cornerRadius= cell.profileImage.frame.size.width / 2;
                cell.profileImage.layer.masksToBounds = YES;
                cell.profileImage.clipsToBounds = YES;
            }

            dicUserInfo = nil;
        }
        
        if (indexPath.row > 0)
        {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                cell.backgroundColor = [UIColor redColor];
                cell.lblTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[arrImageIcons objectAtIndex:indexPath.row]]];
        }
    }
    else //RESTAURANT MENU BINDING
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Profile" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-sideMenu-top.png"]];
            cell.lblUserName.text = [NSString stringWithFormat:@"waiter - %@",[[AppDelegate singleton].dictLogedInRestaurantInfo objectForKey:@"staff_name"]]; //[cell.lblUserName.text stringByAppendingString:[[AppDelegate singleton].dictLogedInRestaurantInfo objectForKey:@"staff_name"]];
            cell.lblrestName.text = [[AppDelegate singleton].dictLogedInRestaurantInfo objectForKey:@"rest_name"];
            NSURL *userProfileImage = [NSURL URLWithString:[[AppDelegate singleton].dictLogedInRestaurantInfo objectForKey:@"rest_logo"]];
            
            [cell.profileImage setImageWithURL:userProfileImage];
            if(userProfileImage == nil)
            {
                cell.profileImage.image = [UIImage imageNamed:@"icon-person-notification.png"];
            }
            cell.profileImage.layer.cornerRadius= cell.profileImage.frame.size.width / 2;
            cell.profileImage.layer.masksToBounds = YES;
            cell.profileImage.clipsToBounds = YES;
        }
        else if (indexPath.row > 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor redColor];
            cell.lblTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.imgIcon.image = [UIImage imageNamed:@""];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AppDelegate singleton].loginType == k_Slide_Menu_UserLogin)
    {
        switch(indexPath.row)
        {
            case 1 :
                [self performSegueWithIdentifier:@"menuToListing" sender:self];
                break;
            
            case 2 :
                [self performSegueWithIdentifier:@"menuToCreditCard" sender:self];
                break;

            case 3 :
                [self performSegueWithIdentifier:@"menuToSetting" sender:self];
                
                break;
            
            case 4 :
                [self performSegueWithIdentifier:@"menuToHistory" sender:self];
                break;
            
            case 5 :
                [self performSegueWithIdentifier:@"menuToNotifications" sender:self];
                break;
                
            case 6 :
                [AppDelegate singleton].userInfo = nil;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [self performSegueWithIdentifier:@"backtoLoginViewController" sender:self];
                break;
        }
    }
    else
    {
        switch(indexPath.row)
        {
            case 1 :
                [self performSegueWithIdentifier:@"WaiterDetailVC" sender:self];
                break;
                
            case 2 :
                [self performSegueWithIdentifier:@"menuToTables" sender:self];
                break;
                
            case 3 :
                //[self performSegueWithIdentifier:@"menuToTables" sender:self];
                [self performSegueWithIdentifier:@"totalOrders" sender:self];
                
                break;
                
            case 4 :
                [self performSegueWithIdentifier:@"menuToSetting" sender:self];
                break;
                
            case 5 :
                [self performSegueWithIdentifier:@"menuToSetting" sender:self];
                break;
                
            case 6 :
                [self performSegueWithIdentifier:@"menuToRestaurantLogin" sender:self];
                break;
                
            case 7 :
                [self performSegueWithIdentifier:@"menuToRestaurantLogin" sender:self];
                break;
                
                
        }
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}






@end
