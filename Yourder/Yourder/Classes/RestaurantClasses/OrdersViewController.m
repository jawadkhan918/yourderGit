//
//  OrdersViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 17/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "OrdersViewController.h"
#import "TableOrdersTableViewCell.h"
#import "SWRevealViewController.h"

@interface OrdersViewController ()
{
    NSMutableArray *arrOrderList;
}

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrOrderList = [[NSMutableArray alloc]init];
    
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self getOrders];

}

-(void)getOrders
{
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"rest_id":[AppDelegate singleton].Rest_key,@"staff_id":[AppDelegate singleton].User_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager GetTablesOrders:dicParams];
}


-(void)DidGetTablesOrdersSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if([[manager.data objectForKey:@"status"] integerValue] == 0)
    {
        NSArray *arrData = [manager.data objectForKey:@"data"];
        
        for(int i=0;i<arrData.count;i++)
        {
            if([[[arrData objectAtIndex:i]objectForKey:@"user_info"] integerValue] > 0)
            {
                for(int j=0;j<[[[arrData objectAtIndex:i] objectForKey:@"user_info"] integerValue];j++)
                {
                    [arrOrderList addObject:[arrData objectAtIndex:j]];
                }
            }
        }
        
        [self.tblOrders reloadData];
       // [self back:self];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
        //[self back:self];
    }
    
}
-(void)DidFailToGetTablesOrders:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"failed");
    
}




# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"CELL";
    TableOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil)
    {
        cell = [[TableOrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:MyIdentifier];
    }
    
    if (arrOrderList.count > 0)
    {
        NSDictionary *dict = [arrOrderList objectAtIndex:indexPath.row];
        if ([[dict objectForKey:@"user_info"] count] > 0)
        {
            
      //  cell.lblDishName.text = [dict objectForKey:@"items_name"]];
        //cell.lblTableNo.text = ;
        cell.lblName.text = [dict objectForKey:@"login_name"];

        }
    }
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
//    
//    if(cell.accessoryType == UITableViewCellAccessoryNone)
//    {
//        [arrSelectTables addObject:[self.arrTablesList objectAtIndex:indexPath.row]];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        [arrSelectTables removeObject:[self.arrTablesList objectAtIndex:indexPath.row]];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    
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
