//
//  ResturantTableViewController.m
//  Yourder
//
//  Created by Kamran Butt on 1/28/16.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "ResturantTableViewController.h"
#import "ResturantOrderTableViewCell.h"
#import "UserOrderViewController.h"

@interface ResturantTableViewController (){

       int expandedRowHeight;
    NSArray *arrDishes;
}

@end

@implementation ResturantTableViewController
{
    NSMutableArray *arrTableDetails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    arrTableDetails = [[NSMutableArray alloc] init];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dicParams = @{@"rest_id":[AppDelegate singleton].Rest_key};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager ResturantTableList:dicParams];

    

    // Do any additional setup after loading the view.
}
-(IBAction)btnBack:(id)sender
{
    [self performSegueWithIdentifier:@"backtoUserLogin" sender:self];
}

-(void)DidResturantTableDetailsSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    arrTableDetails = [manager.data objectForKey:@"data"];
   // arrTableDetails = [NSMutableArray arrayWithObject:dict];
    
    
    [self.Table reloadData];
}
-(void)DidFailToResturantTableDetails:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
     NSLog(@"failed");
}

//-(void) DidResturantLoginSuccessfully:(RapidzzBaseManager *)manager;
//{
//    NSDictionary *dict = manager.data;
//    arrTableDetails = [NSMutableArray arrayWithObject:dict];
//}
//-(void) DidFailToResturantLogin:(RapidzzBaseManager *)manager error:(RapidzzError *)error
//{
//    NSLog(@"failed");
//}

#pragma mark - UITableview Dalegates
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTableDetails.count;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResturantOrderTableViewCell *cell;
    
    //cell = [self.Table dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (arrTableDetails.count > 0)
    {
        NSDictionary *dict = [arrTableDetails objectAtIndex:indexPath.row];
        

        if ([[dict objectForKey:@"user_info"] count] > 0)
        {
            cell = [self.Table dequeueReusableCellWithIdentifier:@"selectedcell" forIndexPath:indexPath];
        }
        else
        {
            cell = [self.Table dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
        ResturantOrderTableViewCell *cell = (ResturantOrderTableViewCell *)[self.Table cellForRowAtIndexPath:indexPath];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        int counter = 0;
        
        expandedRowHeight = 60;
    
        int userAcive = (int)[[[self->arrTableDetails objectAtIndex:indexPath.row]objectForKey:@"user_active"] integerValue];
        if (userAcive > 0)
        {
            
            arrDishes = [[self->arrTableDetails objectAtIndex:indexPath.row] objectForKey:@"user_info"];
            
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
                
                
                
            }
            
            expandedRowHeight = (int)(35 * arrDishes.count) + 100;
            
         
            
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
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
     ResturantOrderTableViewCell *cell
= (ResturantOrderTableViewCell *)[self.Table cellForRowAtIndexPath:indexPath];
    [[cell.userView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return expandedRowHeight;
    }
    return 60.0; // Normal height
}

-(IBAction)Detail:(id)sender
{
    [self performSegueWithIdentifier:@"UserOrderViewController" sender:sender];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    int tag =  (int)((UIButton*)sender).tag;
    UserOrderViewController *detailVC = [segue destinationViewController];
    detailVC.dictSelectedUserInfo = [arrDishes objectAtIndex:tag];
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
