//
//  YourderPopupView.m
//  Yourder
//
//  Created by Rapidzz on 15/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "YourderPopupView.h"

@implementation YourderPopupView
{
    int quantity;
    BOOL splitWithEveryOne;
    BOOL check;
    BOOL userImages;
    int userCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
        self.btnSplitEveryOne.imageView.image = [UIImage imageNamed:@"checkbox-red.png"];
}
*/
 

-(void) bindDishInfo
{
    self.dishSplitUsers = @"";
    [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red.png"] forState:UIControlStateNormal];
    splitWithEveryOne = NO;
    [AppDelegate singleton].addedDishIndex = self.selectedDishIndex;
    self.dictItemInfo = [self.arrMenuItems objectAtIndex:self.selectedDishIndex];
    self.lblDishName.text = [self.dictItemInfo objectForKey:@"item_name"];
    self.lblDishPrice.text = [self.dictItemInfo objectForKey:@"item_price"];
    self.txtQuantity.text = @"1";
    float totalDishPrice = [self.txtQuantity.text intValue] * [[self.dictItemInfo objectForKey:@"item_price"] floatValue];
    self.lblDishTotal.text = [NSString stringWithFormat:@"$%.02f", totalDishPrice];

    NSURL *logoImageURL = [NSURL URLWithString:[self.dictItemInfo objectForKey:@"item_thumbnail"]];
    [self.imgDish setImageWithURL:logoImageURL];
    self.imgDish.layer.cornerRadius = 10;
    self.imgDish.layer.masksToBounds = YES;
    
    self.tbl_bgview.layer.cornerRadius = 20;
    self.tbl_bgview.layer.masksToBounds = YES;
    [AppDelegate singleton].strUsersId = @"";
    [[AppDelegate singleton].arrPersons removeAllObjects];
    
//    if (self.selectedDishIndex == 0)
//    {
//        [self getTableUsers];
//    }
    
}

-(IBAction)next:(id)sender
{
    if (self.selectedDishIndex < (self.arrMenuItems.count-1))
    {
        self.selectedDishIndex++;
        [self bindDishInfo];
    }
}

-(IBAction)Previous:(id)sender
{
    if (self.selectedDishIndex > 0)
    {
        self.selectedDishIndex--;
        [self bindDishInfo];
    }
}

-(IBAction)addQuantity:(id)sender
{
    quantity = [self.txtQuantity.text intValue];
    quantity++;
    self.txtQuantity.text = [NSString stringWithFormat:@"%d",quantity];
    self.lblDishTotal.text = [NSString stringWithFormat:@"$%.02f", [self.lblDishPrice.text floatValue] * quantity];
}

-(IBAction)lessQuantity:(id)sender
{
    quantity = [self.txtQuantity.text intValue];
    if (quantity > 1)
    {
        quantity--;
        self.txtQuantity.text = [NSString stringWithFormat:@"%d",quantity];
        self.lblDishTotal.text = [NSString stringWithFormat:@"$%.02f", [self.lblDishPrice.text floatValue] * quantity];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:@"Quantity can not be 0"];
    }
}



#pragma mark GET TABLE USERS

-(void) getTableUsers
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSDictionary *dictParams = @{@"barcode_value":[AppDelegate singleton].userTableBarcode,
                                 @"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]};
    
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager getTableUser:dictParams];
}

-(void) didGetTableUsersSuccessfully:(RapidzzBaseManager *)manager
{
    self.arrUsers = [manager.data objectForKey:@"data"];
    
    self.tblUsers.delegate = self;
    self.tblUsers.dataSource = self;
    [self.tblUsers reloadData];
    [MBProgressHUD hideHUDForView:self animated:YES];
}

-(void) didGetTableUsersFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self animated:YES];
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
    YourderPopupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSString *strUserID = [[self.arrUsers objectAtIndex:indexPath.row]objectForKey:@"login_id"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    userCount++;
    if(userCount >3)
        userImages = YES;
    
    
    if (cell == nil)
    {
        cell = [[YourderPopupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = [[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"table_username"];
    
    NSURL *agentImageURL = [NSURL URLWithString:[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"profile_picture"]];
    
    
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
    
    if ([[[self.arrUsers objectAtIndex:indexPath.row] objectForKey:@"profile_picture"] length] < 10)
    {
        cell.imageView.image = [UIImage imageNamed:@"icon-person-notification.png"];
    }
    
    else
    {
        if(userImages == NO)
        {
            NSData *imageData = [NSData dataWithContentsOfURL:agentImageURL];
            cell.imageView.image = [UIImage imageWithData:imageData];
            cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:agentImageURL]];
        }
        else
        {
            [cell.imageView setImageWithURL:agentImageURL];
        }
        cell.imageView.layer.cornerRadius=20;
        cell.imageView.layer.masksToBounds = YES;
        
    }
    
    for(int i=0;i<[AppDelegate singleton].arrPersons.count;i++)
    {
        NSString *strPersonID = [[[AppDelegate singleton].arrPersons objectAtIndex:i]objectForKey:@"login_id"];
        
        if([strPersonID isEqualToString:strUserID])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    if(splitWithEveryOne == YES)
    {
        [AppDelegate singleton].strUsersId = @"";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if(splitWithEveryOne == NO && check == YES)
    {
        [AppDelegate singleton].strUsersId = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        check = NO;
        [AppDelegate singleton].arrPersons = [[NSMutableArray alloc]init];
    }
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f];
        //cell.backgroundColor = [UIColor lightGrayColor];
    
    else
        cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
    
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //GHAFAR CODE
    NSLog(@"image selected");
    userImages =YES;
    
    if ([self.tblUsers cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone)
    {
        [self.tblUsers cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [[AppDelegate singleton].arrPersons addObject:[self.arrUsers objectAtIndex:indexPath.row]];
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red.png"] forState:UIControlStateNormal];
        splitWithEveryOne = NO;
    }
    else
    {
        [self.tblUsers cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [[AppDelegate singleton].arrPersons removeObject:[self.arrUsers objectAtIndex:indexPath.row]];
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red.png"] forState:UIControlStateNormal];
        splitWithEveryOne = NO;
    }
    if([AppDelegate singleton].arrPersons.count == self.arrUsers.count)
    {
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red-checked.png"] forState:UIControlStateNormal];
        splitWithEveryOne = YES;
    }
    
    

    /*
    NSLog(@"image selected");
    
    if ([self.tblUsers cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone)
    {
        [self.tblUsers cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [[AppDelegate singleton].arrPersons addObject:[self.arrUsers objectAtIndex:indexPath.row]];
    }
    else
    {
        [self.tblUsers cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [[AppDelegate singleton].arrPersons removeObject:[self.arrUsers objectAtIndex:indexPath.row]];
    }
    if([AppDelegate singleton].arrPersons.count != 0)
    {
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red.png"] forState:UIControlStateNormal];
        splitWithEveryOne = NO;
    }
    
    
    [AppDelegate singleton].strUsersId = @"";
    for(int i=0;i<[AppDelegate singleton].arrPersons.count;i++)
    {
        if(![[AppDelegate singleton].strUsersId isEqualToString:@""])
        {
            [AppDelegate singleton].strUsersId = [[AppDelegate singleton].strUsersId stringByAppendingString:@","];
        }
        
        [AppDelegate singleton].strUsersId = [[AppDelegate singleton].strUsersId stringByAppendingString:[[[AppDelegate singleton].arrPersons objectAtIndex:i]objectForKey:@"login_id"]];
        
    }
    */
}

/*
-(IBAction)btnSplitWithEveryOne:(id)sender
{
    if (splitWithEveryOne == NO)
    {
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red-checked.png"] forState:UIControlStateNormal];
        splitWithEveryOne = YES;
        
        [self splitWith];
        [self.tblUsers reloadData];
    }
    else
    {
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red.png"] forState:UIControlStateNormal];
        splitWithEveryOne = NO;
        check= YES;
        [self.tblUsers reloadData];
        
        //self.btnSplitEveryOne.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"checkbox-red.png"]];
    }
}
*/
 
-(void)selectAllPersons
{
    for (UITableViewCell *cell in [self.tblUsers visibleCells])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}
-(void)deselectAllPersons
{
    for (UITableViewCell *cell in [self.tblUsers visibleCells])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

-(IBAction)btnSplitWithEveryOne:(id)sender
{
    if (splitWithEveryOne == NO)
    {
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red-checked.png"] forState:UIControlStateNormal];
        for(int i=0;i<self.arrUsers.count;i++)
        {
            [[AppDelegate singleton].arrPersons addObject:[self.arrUsers objectAtIndex:i]];
        }
        splitWithEveryOne = YES;
        [self splitWith];
        //[self.tblUsers reloadData];
        [self selectAllPersons];
    }
    else
    {
        [self.btnSplitEveryOne setBackgroundImage:[UIImage imageNamed:@"checkbox-red.png"] forState:UIControlStateNormal];
        for(int i=0;i<self.arrUsers.count;i++)
        {
            [[AppDelegate singleton].arrPersons removeObject:[self.arrUsers objectAtIndex:i]];
        }
        
        splitWithEveryOne = NO;
        check= YES;
        [self deselectAllPersons];
        //[self.tblUsers reloadData];
        
        //self.btnSplitEveryOne.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"checkbox-red.png"]];
    }
}


-(void) splitWith
{
    
    //KARIM CODE
//    if (splitWithEveryOne == YES)
//    {
//        for ( int i = 0; i< self.arrUsers.count; i++)
//        {
//            self.dishSplitUsers = [NSString stringWithFormat:@"%@,",[[self.arrUsers objectAtIndex:i] objectForKey:@"login_id"]];
//        }
//    }

    
    //GHAFAR CODE (NOT GOOD)
    
        if (splitWithEveryOne == YES)
        {
            for ( int i = 0; i< [AppDelegate singleton].arrPersons.count; i++)
            {
                self.dishSplitUsers = [NSString stringWithFormat:@"%@,",[[[AppDelegate singleton].arrPersons objectAtIndex:i] objectForKey:@"login_id"]];
            }
        }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}







@end
