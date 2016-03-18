//
//  RightSliderViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 08/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "RightSliderViewController.h"

@interface RightSliderViewController ()
{
    float totalAmount;
    NSArray *arrUserDishes;
    NSDictionary *serviceResponse;
}
@end

@implementation RightSliderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    totalAmount = 0;
    
    [self getDishes];
}

-(void)getDishes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    arrUserDishes = [[NSArray alloc] init];
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    //NSLog(@"dict%@",[AppDelegate singleton].userInfo);
    NSDictionary *dict = @{@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                           ,@"status":@"1"};
    [self.manager getUserDishes:dict];
}

-(void)DidGetUserDishesSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    serviceResponse = manager.data;
    arrUserDishes = [manager.data objectForKey:@"order_detail"];
    [self.tblOrder reloadData];
    for (int i = 0; i<arrUserDishes.count; i++)
    {
        totalAmount = totalAmount + [[[arrUserDishes objectAtIndex:i] objectForKey:@"uPay"] floatValue];
        self.lblTotalAmount.text = [NSString stringWithFormat:@"$%.02f",totalAmount]; //[serviceResponse objectForKey:@"order_totalbill"]; //[NSString stringWithFormat:@"%lu",(unsigned long)totalAmount];
        
        [self.btnCancel setTitle:self.lblTotalAmount.text forState:UIControlStateNormal];
    }
}

-(void)DidFailToGetUserDishes:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrUserDishes count];
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
    
    NSDictionary *dict = [arrUserDishes objectAtIndex:indexPath.row];
    cell.lblDishName.text = [dict objectForKey:@"item_name"];
    cell.lblYouPay.text = [NSString stringWithFormat:@"$%.02f",[[dict objectForKey:@"uPay"] floatValue]]; //[NSString stringWithFormat:@"$%.02f", youpay];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSplitDetailPopUp:indexPath];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[AppDelegate singleton].alertView removeFromSuperview];
}


#pragma mark - SPLIT POPUP

- (IBAction)showSplitDetailPopUp:(id)sender
{
    int index = (int)((NSIndexPath *)sender).row;
    [AppDelegate singleton].alertView = [[CustomIOSAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    self.alertView.tag = 1001;
    [[AppDelegate singleton].alertView setContainerView:[self createPopup:index]];
    
    // Modify the parameters
    [[AppDelegate singleton].alertView setButtonTitles:nil];
    [[AppDelegate singleton].alertView setDelegate:self];
    [[AppDelegate singleton].alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [[AppDelegate singleton].alertView show];
}

- (UIView *) createPopup: (int) index
{
    UIView *demoView;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    self.objSplitDetailPopUp.view.frame = CGRectMake(0, 0, 280, 300);
    self.objSplitDetailPopUp = [self.storyboard instantiateViewControllerWithIdentifier:@"SplitDetailPopVC"];
    //ADD BUTTONS METHODS
    [self.objSplitDetailPopUp.btnClose addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.objSplitDetailPopUp.dictDishDetail = [arrUserDishes objectAtIndex:index];
    
    [demoView addSubview:self.objSplitDetailPopUp.view];
    //[demoView addSubview:self.objSplitDetailPopUp];
    return demoView;
    
}


-(IBAction)btnCancel:(id)sender
{
    //[[self.view viewWithTag:1001] removeFromSuperview];
    //[[AppDelegate singleton].arrCurrOrder removeAllObjects];
    [self.alertView close];
}

-(IBAction)btnDone:(id)sender
{
    //[[self.view viewWithTag:1001] removeFromSuperview];
    [self.alertView close];
    
    //[self saveOrder];
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
