//
//  WaiterDetailViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 16/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "WaiterDetailViewController.h"
#import "ResturantOrderTableViewCell.h"
#import "UserOrderViewController.h"

@interface WaiterDetailViewController ()
{
    int expandedRowHeight;
    NSArray *arrDishes;
}


@end

@implementation WaiterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrWaiterTabels = [[NSMutableArray alloc]init];
    self.lblWaiterName.text = [self.lblWaiterName.text stringByAppendingString:[AppDelegate singleton].Waiter_Name];
    
    
    //SLIDEBAR VIEW
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
  
}

-(void)getWaiterTabels
{
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"rest_id":[AppDelegate singleton].Rest_key,@"staff_id":[AppDelegate singleton].User_id};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager ResturantTableList:dicParams];
}

-(void)DidResturantTableDetailsSuccessfully:(RapidzzBaseManager *)manager
{
    if([[manager.data objectForKey:@"status"] integerValue] == 0)
    {
       // NSArray *arrData = [[NSArray alloc]initWithArray:[manager.data objectForKey:@"data"]];
        self.arrWaiterTabels = [manager.data objectForKey:@"data"];
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
        [self.tblTables reloadData];
      
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];

    }
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)DidFailToResturantTableDetails:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"failed");
}





-(IBAction)selectTables:(id)sender
{
    [self performSegueWithIdentifier:@"tableListVC" sender:self];
}


# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrWaiterTabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    ResturantOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[ResturantOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
    }
    
    if (self.arrWaiterTabels.count > 0)
    {
        NSDictionary *dict = [self.arrWaiterTabels objectAtIndex:indexPath.row];
        
        
        if ([[dict objectForKey:@"user_info"] count] > 0)
        {
            cell = [self.tblTables dequeueReusableCellWithIdentifier:@"selectedcell" forIndexPath:indexPath];
        }
        else
        {
            cell = [self.tblTables dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        }
        
        cell.lblTableNumber.text = [NSString stringWithFormat:@"Table %@",[dict objectForKey:@"table_number"]];
        cell.lblTableBarcode.text = [NSString stringWithFormat:@"Barcode: %@",[dict objectForKey:@"barcode_value"]];
        cell.lblActiveUser.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_active"]];
        
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    /// Condition applied for data crime
    
    //    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame)
    //    {
    self.expandedIndexPath = indexPath;
    ResturantOrderTableViewCell *cell = (ResturantOrderTableViewCell *)[self.tblTables cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int counter = 0;
    
    expandedRowHeight = 60;
    
    int userAcive = (int)[[[self.arrWaiterTabels objectAtIndex:indexPath.row]objectForKey:@"user_active"] integerValue];
    if (userAcive > 0)
    {
        
        arrDishes = [[self.arrWaiterTabels objectAtIndex:indexPath.row] objectForKey:@"user_info"];
        
        int y = (40) * counter;
        UIButton *lblHeading;
        UILabel *separator;
        UIImageView *img;
        UIButton *click;
        
        for (int i = 0; i<arrDishes.count; i++)
        {
            y = 40 * i;
            NSDictionary *dict = [arrDishes objectAtIndex:i];
            //ADD LABEL
            lblHeading = [[UIButton alloc] initWithFrame:CGRectMake(50,y-3,200, 40)];
            [lblHeading setTitle:[[arrDishes objectAtIndex:i] objectForKey:@"login_name"] forState:UIControlStateNormal];
            [lblHeading setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //lblHeading.titleLabel.text = [[arrDishes objectAtIndex:i] objectForKey:@"login_name"]; //@"test";
            [lblHeading setFont:[UIFont systemFontOfSize:13]];
            lblHeading.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            lblHeading.tag = i;
          //  [lblHeading addTarget:self action:@selector(Detail:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            NSURL *logoImageURL = [NSURL URLWithString:[dict objectForKey:@"profile_picture"]];
            
            
            
            img = [[UIImageView alloc]initWithFrame:CGRectMake(5,y+2,30,30)];
            img.layer.cornerRadius = img.frame.size.height/2;
            img.layer.masksToBounds = YES;
            img.layer.borderWidth = 0;
            [img setImageWithURL:logoImageURL];
            
            if ([[dict objectForKey:@"profile_picture"] length] < 10)
            {
                img.image = [UIImage imageNamed:@"icon-person-notification.png"];
            }
            
            
            separator = [[UILabel alloc] initWithFrame:CGRectMake(0,img.frame.origin.y+img.frame.size.height+4,self.view.frame.size.width,1)];
            separator.backgroundColor = [UIColor whiteColor];
            
            click = [[UIButton alloc]initWithFrame:CGRectMake(0,y,self.view.frame.size.width,38)];
          //  [click addTarget:self action:@selector(Detail:) forControlEvents:UIControlEventTouchUpInside];
            
            click.tag = i;
            cell.userView.translatesAutoresizingMaskIntoConstraints = YES;
            cell.userView.frame = CGRectMake(0,46,self.view.frame.size.width,191+y);
            
            
            [cell.userView addSubview:img];
            
            [cell.userView addSubview:click];
            
            [cell.userView addSubview:lblHeading];
            [cell.userView addSubview:separator];
            
            
            
        }
        
        expandedRowHeight = (int)(35.5 * arrDishes.count) + 100;
        
        
        
    }
    
    
    
    
    //}
    else
    {
        self.expandedIndexPath = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //HistoryTableViewCell *cellCheck = (HistoryTableViewCell *)[self.tblOrder cellForRowAtIndexPath:indexPath];
        //cellCheck.lblMessage.hidden = NO;
        
        
    }
    
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return expandedRowHeight;
    }
    return 60.0; // Normal height
}




-(void) viewWillAppear: (BOOL) animated
{
    self.arrWaiterTabels = [AppDelegate singleton].arrSelectedTabels;
    [self getWaiterTabels];
    
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
