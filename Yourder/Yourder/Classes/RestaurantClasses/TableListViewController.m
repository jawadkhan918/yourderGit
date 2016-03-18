//
//  TableListViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 16/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "TableListViewController.h"

@interface TableListViewController ()
{
   
    NSString *strSelectedTables;
    NSMutableArray *arrSelectTables;
}

@end

@implementation TableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.arrTablesList = [[NSMutableArray alloc] init];
    arrSelectTables = [[NSMutableArray alloc]init];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"rest_id":[AppDelegate singleton].Rest_key};
    
    [AppDelegate singleton].arrSelectedTabels = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedTables"];
    
    for(int i=0;i<[AppDelegate singleton].arrSelectedTabels.count;i++)
    {
        [arrSelectTables addObject:[[AppDelegate singleton].arrSelectedTabels objectAtIndex:i]];
    }
    //arrSelectTables = [AppDelegate singleton].arrSelectedTabels;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager ResturantTableList:dicParams];

}

-(void)DidResturantTableDetailsSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.arrTablesList = [manager.data objectForKey:@"data"];
    // arrTableDetails = [NSMutableArray arrayWithObject:dict];
    
    
    [self.tblTables reloadData];
}
-(void)DidFailToResturantTableDetails:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    NSLog(@"failed");
}


# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrTablesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    ResturantOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil)
    {
        cell = [[ResturantOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:MyIdentifier];
    }
    
    if (self.arrTablesList.count > 0)
    {
        NSDictionary *dict = [self.arrTablesList objectAtIndex:indexPath.row];
        
        
        for(int i=0;i<arrSelectTables.count;i++)
        {
            NSString *strService = [[self.arrTablesList objectAtIndex:indexPath.row] objectForKey:@"barcode_value"];
            NSString *strSelectService = [[arrSelectTables objectAtIndex:i] objectForKey:@"barcode_value"];
            
            if([strSelectService isEqualToString:strService])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
        }
        cell.lblTableNumber.text = [NSString stringWithFormat:@"Table %@",[dict objectForKey:@"table_number"]];
        cell.lblTableBarcode.text = [NSString stringWithFormat:@"Barcode: %@",[dict objectForKey:@"barcode_value"]];
       // cell.lblActiveUser.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_active"]];
        
    }

    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [arrSelectTables addObject:[self.arrTablesList objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [arrSelectTables removeObject:[self.arrTablesList objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
   
}

-(IBAction)SaveTables:(id)sender
{
   
    strSelectedTables= @"";
    for(int i = 0;i<arrSelectTables.count;i++)
    {
        if(![strSelectedTables isEqualToString:@""])
        {
            strSelectedTables = [strSelectedTables stringByAppendingString:@","];
        }
        
        strSelectedTables = [strSelectedTables stringByAppendingString:[[arrSelectTables objectAtIndex:i]objectForKey:@"table_id"]];
     
    }
    [[NSUserDefaults standardUserDefaults]setObject:arrSelectTables forKey:@"selectedTables"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self addWaiterTables];

}

-(void)addWaiterTables
{
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"rest_id":[AppDelegate singleton].Rest_key,@"table_id":strSelectedTables,@"staff_id":[AppDelegate singleton].User_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager SaveWaiterTables:dicParams];
}


-(void)DidSaveWaiterTablesSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
   if([[manager.data objectForKey:@"status"] integerValue] == 0)
   {
       
       [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
       [self back:self];
   }
   else
   {
     [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
     [self back:self];
   }

}
-(void)DidFailToSaveWaiterTables:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"failed");

}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
