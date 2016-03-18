//
//  creditCardViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 26/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "creditCardViewController.h"
#import "CardPaymentTableViewCell.h"
#import "SWRevealViewController.h"

@interface creditCardViewController ()
{
    NSArray *arrCards;
    NSMutableArray *arrCardID;
    int cardId;
}


@end

@implementation creditCardViewController

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

    
    
    
    self.tblCards.delegate = self;
    arrCards = [[NSArray alloc]init];
    arrCardID = [[NSMutableArray alloc]init];
    [self getCards];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *) createPopup: (int) index
{
    UIView *demoView;
    self.cardPopUp = [self.storyboard instantiateViewControllerWithIdentifier:@"addCardVC"];
    //float Y_Co = self.view.frame.size.height - 430;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250  , 350)];
    self.cardPopUp.view.frame = CGRectMake(0, 0, 250, 350);
    
    //ADD BUTTONS METHODS
    [self.cardPopUp.btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
     [self.cardPopUp.btnDone addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.cardPopUp.btnDone addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [demoView addSubview:self.cardPopUp.view];
    return demoView;
}

//DONE AND CANCEL BUTTON
-(IBAction)btnCancel:(id)sender
{
    //[self.placeOrderView removeFromSuperview];
    
    
    [self.alertView close];
    
}

-(IBAction)btnDone:(id)sender
{
    //[self.placeOrderView removeFromSuperview];
    
    
    if([self validationChecks] == YES )
    {
        [self.alertView close];
        [self addCards];
        
    }
}

//CALL ADD CARD WEBSERVICE
-(void)addCards
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    NSDictionary *dict = @{@"complete_name":self.cardPopUp.txtName.text,
                           @"card_number":self.cardPopUp.txtCardNo.text,
                           @"card_expiry":self.cardPopUp.txtcardExpiry.text,
                           @"card_cvv":self.cardPopUp.txtCardCVV.text,
                           @"login_id":[[[AppDelegate singleton]userInfo]objectForKey:@"login_id"]};
    
    [self.manager addCardDetail:dict];
}

-(void)DidAddCardSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
        [self getCards];
        
    }
    else
    {
         [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
    }
}

-(void)DidFailToAddCard:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    NSLog(@"failed");
}



//CALL GET ALL CARDS WEBSERVICE
-(void)getCards
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.manager = [[RapidzzUserManager alloc]init];
    self.manager.delegate = self;
    NSDictionary *dict = @{@"login_id":[[[AppDelegate singleton]userInfo]objectForKey:@"login_id"]};
    [self.manager getAllCards:dict];
}


-(void)DidGetCardsSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        arrCards = [dictResult objectForKey:@"data"];
       
        [self.tblCards reloadData];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
        arrCards = [[NSArray alloc]init];
        [self.tblCards reloadData];
    }
}
-(void)DidFailToGetCards:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    NSLog(@"Failed");
}


//CALL DELETE CARD WEBSERVICE
-(IBAction)delete:(id)sender
{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Are you sure ??" message:@"You want to delete this card" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    [alert show];
    cardId =(int)((UIButton *)sender).tag;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        
        self.manager = [[RapidzzUserManager alloc]init];
        self.manager.delegate = self;
        
        NSDictionary *dict = @{@"card_id":[NSString stringWithFormat:@"%d",cardId]};
        
        [self.manager deleteCard:dict];
   }
}
-(void)DidDeleteCardSuccessfully:(RapidzzBaseManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
        [self getCards];
    [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
}

-(void)DidFailToDeleteCard:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[AppDelegate singleton] showAlertwith:nil andMessage:k_API_Failed_Message];
}



# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cardPayment";
   CardPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[CardPaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
    }
    
    //DELETE BUTTION
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete addTarget:self
               action:@selector(delete:)
     forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [btnDelete.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"btn-red-1.png"] forState:UIControlStateNormal];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        btnDelete.frame = CGRectMake(260, 20, 50.0, 21.0);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        btnDelete.frame = CGRectMake(315, 20, 50.0, 21.0);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        btnDelete.frame = CGRectMake(350, 20, 50.0, 21.0);
    }
    
    btnDelete.tag = [[[arrCards objectAtIndex:indexPath.row]objectForKey:@"card_id"] intValue];
    [cell addSubview:btnDelete];
    
    //LABLELS
    cell.lblName.text = [[arrCards objectAtIndex:indexPath.row]objectForKey:@"complete_name"];
    cell.lblCardNo.text = [[arrCards objectAtIndex:indexPath.row]objectForKey:@"card_number"];
    cell.lblExpiryDate.text = [[arrCards objectAtIndex:indexPath.row]objectForKey:@"card_expiry"];
    [arrCardID addObject:[[arrCards objectAtIndex:indexPath.row]objectForKey:@"card_id"]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"done");
    
    //[self performSegueWithIdentifier:@"RestaurantlistingToDetail" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    RestaurantDetailViewController *detailVC = [segue destinationViewController];
//    detailVC.dictSelectedRestaurant = dictSelectedRestaurant;
}



-(BOOL) validationChecks
{
    BOOL isFormFilled = YES;
    NSString *message;
    
    if (self.cardPopUp.txtName.text.length ==0)
    {
        message = @"Please enter name ";
        isFormFilled = NO;
    }
    else if (self.cardPopUp.txtCardNo.text.length != 12)
    {
        message = @"Please enter valid card number";
        isFormFilled = NO;
    }
    else if (self.cardPopUp.txtcardExpiry.text.length == 0)
    {
        message = @"Please enter card expiry date";
        isFormFilled = NO;
    }
    else if (self.cardPopUp.txtCardCVV.text.length != 3)
    {
        message = @"Please enter valid cardCVV";
        isFormFilled = NO;
    }
    if(isFormFilled == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return isFormFilled;
}







-(IBAction)addCard:(id)sender
{
    self.alertView = [[CustomIOSAlertView alloc] init];
    self.alertView.tag = 1001;
    // Add some custom content to the alert view
    [self.alertView setContainerView:[self createPopup:0]];
    
    // Modify the parameters
    [self.alertView setButtonTitles:nil];
    //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", nil]];
    [self.alertView setDelegate:self];
    
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
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
