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
    NSString *strSelectedTables;
    NSMutableArray *arrSelectTables;
    int expandedRowHeight;
    BOOL isExpand;
    NSArray *arrDishes;
    ResturantOrderTableViewCell *currentCell;
    int index;
    
}


@end

@implementation WaiterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrSelectTables = [[NSMutableArray alloc]init];
    
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
    
        self.arrWaiterTabels = [AppDelegate singleton].arrSelectedTabels;
        [self getWaiterTabels];
  
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
    arrSelectTables = [[NSMutableArray alloc]init];
    if([[manager.data objectForKey:@"status"] integerValue] == 0)
    {
       // NSArray *arrData = [[NSArray alloc]initWithArray:[manager.data objectForKey:@"data"]];
        self.arrWaiterTabels = [manager.data objectForKey:@"data"];
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
        for(int i=0;i<self.arrWaiterTabels.count;i++)
        {
            NSDictionary *dict = [self.arrWaiterTabels objectAtIndex:i];
            if([[dict objectForKey:@"table_assign"] integerValue] == 0)
            {
                [arrSelectTables addObject:[self.arrWaiterTabels objectAtIndex:i]];
                
            }
        }
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
    
        cell.btnSelected.tag = (int)indexPath.row;
        
        if([[dict objectForKey:@"table_assign"] integerValue] == 0)
        {
            UIImage *btnImage = [UIImage imageNamed:@"star_filled@2x.png"];
            [cell.btnSelected setImage:btnImage forState:UIControlStateNormal];
           // [arrSelectTables addObject:[self.arrWaiterTabels objectAtIndex:indexPath.row]];
           
        }
        else
        {
            UIImage *btnImage = [UIImage imageNamed:@"star_unfilled@2x.png"];
            [cell.btnSelected setImage:btnImage forState:UIControlStateNormal];
            
        }
        
         int userAcive = (int)[[[self.arrWaiterTabels objectAtIndex:indexPath.row]objectForKey:@"user_active"] integerValue];
        
        if (userAcive > 0)
        {
             cell.btnColor.backgroundColor = [UIColor greenColor];
        }
        else
        {
            cell.btnColor.backgroundColor = [UIColor redColor];
        }
        cell.btnColor.layer.cornerRadius= cell.btnColor.frame.size.width / 2;
        cell.btnColor.layer.masksToBounds = YES;
        cell.btnColor.clipsToBounds = YES;

        
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
    currentCell = cell;
    // [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int counter = 0;
    
    expandedRowHeight = 60;
    
    int userAcive = (int)[[[self.arrWaiterTabels objectAtIndex:indexPath.row]objectForKey:@"user_active"] integerValue];
    if(cell.isExpand == NO)
    {
        cell.userView.hidden = NO;
        if (userAcive > 0)
        {
            
            arrDishes = [[self.arrWaiterTabels objectAtIndex:indexPath.row] objectForKey:@"user_info"];
            
            int y = (40) * counter;
            UIButton *lblHeading;
            UILabel *separator;
            UIImageView *img;
            UIButton *click;
            cell.userView.layer.sublayers = nil;
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
                [lblHeading addTarget:self action:@selector(Detail:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
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
                [click addTarget:self action:@selector(Detail:) forControlEvents:UIControlEventTouchUpInside];
                
                click.tag = i;
                cell.userView.translatesAutoresizingMaskIntoConstraints = YES;
                cell.userView.frame = CGRectMake(0,46,self.view.frame.size.width,191+y);
                
                
                [cell.userView addSubview:img];
                
                [cell.userView addSubview:click];
                
                [cell.userView addSubview:lblHeading];
                [cell.userView addSubview:separator];
                
              cell.isExpand = YES;
                
            }
            
            expandedRowHeight = (int)(35 * arrDishes.count) + 100;
            
            
        }
        else
        {
            self.expandedIndexPath = nil;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            
        }
        
    }
    else
    {
       cell.isExpand = NO;
        self.expandedIndexPath = nil;
        cell.userView.hidden = YES;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView endUpdates];
    
    
    //}
   
    
    
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ResturantOrderTableViewCell *cell = (ResturantOrderTableViewCell *)[self.tblTables cellForRowAtIndexPath:indexPath];
    cell.isExpand = NO;
    cell.userView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"userOrdersVC"])
    {
        // Get reference to the destination view controller
        UserOrderViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.dictSelectedUserInfo = [arrDishes objectAtIndex:index];
    }
}
-(IBAction)Detail:(id)sender
{
    UIButton *button = (UIButton *)sender;
    index = (int)button.tag;
    [self performSegueWithIdentifier:@"userOrdersVC" sender:sender];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return expandedRowHeight;
    }
    return 60.0;
}

-(IBAction)SaveTables:(id)sender
{
        UIButton *button = (UIButton *)sender;
    if ([arrSelectTables containsObject:[self.arrWaiterTabels objectAtIndex:button.tag]])
    {
         [arrSelectTables removeObject:[self.arrWaiterTabels objectAtIndex:(int)button.tag]];
        
    }
    else
    {
       [arrSelectTables addObject:[self.arrWaiterTabels objectAtIndex:(int)button.tag]];
    }
    
    
    strSelectedTables= @"";
    for(int i = 0;i<arrSelectTables.count;i++)
    {
        if(![strSelectedTables isEqualToString:@""])
        {
            strSelectedTables = [strSelectedTables stringByAppendingString:@","];
        }
        
        strSelectedTables = [strSelectedTables stringByAppendingString:[[arrSelectTables objectAtIndex:i]objectForKey:@"table_id"]];
        
    }
       
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
        [self getWaiterTabels];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[manager.data objectForKey:@"message"]];
    }
    
}
-(void)DidFailToSaveWaiterTables:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"failed");
    
}






-(void) viewWillAppear: (BOOL) animated
{
//    self.arrWaiterTabels = [AppDelegate singleton].arrSelectedTabels;
//    [self getWaiterTabels];
//    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
