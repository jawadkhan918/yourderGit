//
//  HistoryViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 11/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    int expandedRowHeight;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //SLIDEBAR VIEW
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    [self getUserOrderHistory];
}

-(void) getUserOrderHistory
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.arrOrderHistory = [[NSMutableArray alloc] init];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    NSDictionary *dicParams = @{@"login_id":[dict objectForKey:@"login_id"]
                                };
    [self.manager getUserOrderHistory:dicParams];
}


-(void) DidGetOrderHistorySuccessfully:(RapidzzBaseManager *)manager
{
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        self.arrOrderHistory = [self.manager.data objectForKey:@"data"];
        [self.tblOrder reloadData];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
    }
    
    //self.arrOrderHistory = self.manager.data;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) DidGetOrderHistoryFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


# pragma mark - TABLE DELEGATES

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrOrderHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:MyIdentifier];
    }
    
    //int index = (int)indexPath.row;
    NSDictionary *dict = [self.arrOrderHistory objectAtIndex:indexPath.row];
    
    cell.lblRestName.text = [dict objectForKey:@"rest_name"];
    cell.lblRestAddress.text = [dict objectForKey:@"rest_address"];
    cell.lblDate.text = [dict objectForKey:@"order-datetime"];
    
    NSURL *logoImageURL = [NSURL URLWithString:[dict objectForKey:@"rest_logo"]];
    [cell.imgRestLogo setImageWithURL:logoImageURL];
    cell.imgRestLogo.layer.cornerRadius = cell.imgRestLogo.frame.size.width / 2;
    cell.imgRestLogo.layer.masksToBounds = YES;
    cell.imgRestLogo.clipsToBounds = YES;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView beginUpdates];
    /// Condition applied for data crime
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame)
    {
        self.expandedIndexPath = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //HistoryTableViewCell *cellCheck = (HistoryTableViewCell *)[self.tblOrder cellForRowAtIndexPath:indexPath];
        //cellCheck.lblMessage.hidden = NO;
        
    }
    else
    {
        self.expandedIndexPath = indexPath;
        HistoryTableViewCell *cellCheck = (HistoryTableViewCell *)[self.tblOrder cellForRowAtIndexPath:indexPath];
        [[cellCheck.contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        int counter = 0;
        
        expandedRowHeight = 60;
        float total = 0;
        if ([[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"order_detail"] count] > 0)
        {
        
            NSArray *arrDishes = [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"order_detail"];
            
            int y = (40) * counter;
            UILabel *lblHeading;
            UILabel *lblValue;
            for (int i = 0; i<arrDishes.count; i++)
            {
                y = 40 * i;
                //ADD LABEL
                lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 200, 40)];
                lblHeading.text = [[arrDishes objectAtIndex:i] objectForKey:@"item_name"]; //@"test";
                [lblHeading setFont:[UIFont systemFontOfSize:13]];
                [cellCheck.contentContainer addSubview:lblHeading];
                
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(230, y, 70, 40)];
                lblValue.text = [[arrDishes objectAtIndex:i] objectForKey:@"item_price"]; //@"test";
                [lblValue setFont:[UIFont systemFontOfSize:13]];
                lblValue.textAlignment = NSTextAlignmentRight;
                [cellCheck.contentContainer addSubview:lblValue];
                total = total + [[[arrDishes objectAtIndex:i] objectForKey:@"item_price"] floatValue];
            }
            
            expandedRowHeight = (int)(40 * arrDishes.count) + 100;
            
            //BIND TOTAL BILL
            y = 40 * (int)arrDishes.count;
            //ADD LABEL
            lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 200, 40)];
            lblHeading.text = @"Total";
            [lblHeading setFont:[UIFont systemFontOfSize:13]];
            lblHeading.textColor = [UIColor redColor];
            [cellCheck.contentContainer addSubview:lblHeading];
            
            lblValue = [[UILabel alloc] initWithFrame:CGRectMake(230, y, 70, 40)];
            lblValue.text = [NSString stringWithFormat:@"%0.2f",total];  //[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"order_totalbill"];
            [lblValue setFont:[UIFont systemFontOfSize:13]];
            lblValue.textAlignment = NSTextAlignmentRight;
            lblValue.textColor = [UIColor redColor];
            [cellCheck.contentContainer addSubview:lblValue];
        }
    }
    
    [tableView endUpdates]; // tell the table you're done making your changes
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    HistoryTableViewCell *cellCheck = (HistoryTableViewCell *)[self.tblOrder cellForRowAtIndexPath:indexPath];
    [[cellCheck.contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return expandedRowHeight;
    }
    return 60.0; // Normal height
}


- (void)didReceiveMemoryWarning
{
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
