//
//  RestaurantMenuViewController.m
//  Yourder
//
//  Created by Rapidzz on 24/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import "RestaurantMenuViewController.h"
#import "UIImageView+WebCache.h"


@interface RestaurantMenuViewController ()
{
    NSString *deviceType;
    UIButton *preCatButton;
    UIImageView *preCatLine;
    int pagerIndex;
    int pageIndex;
    BOOL pagerStartFirstTime;
    AppDelegate *delegate;
    UIView *serviceView;
    UIView *emptyView;
    
}

@end

@implementation RestaurantMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    deviceType = [UIDevice currentDevice].model;
    pagerIndex = 0;
    pageIndex = 0;
    pagerStartFirstTime = YES;
    
    //SLIDEBAR VIEW
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    [self.scrCatgories setScrollEnabled:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //CALL BINDING METHODS
    [self getRestaurantMenuCategories];
    [self bindRestInfo];
    
    // SET RIGHT SLIDER VALUE
     //[self.btnRightSlider setTitle:[NSString stringWithFormat:@"$%.02f",[[[AppDelegate singleton].dictUserPreviousOrderDetail objectForKey:@"total_price"] floatValue]] forState:UIControlStateNormal];
    
    [self.btnRightSlider setTitle:[NSString stringWithFormat:@"$%.02f",[AppDelegate singleton].totalBillAmount] forState:UIControlStateNormal];
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview: self.btnServiceRequest];
   
}



-(void) bindRestInfo
{
    NSURL *agentImageURL = [NSURL URLWithString:[self.dictSelectedRestaurant objectForKey:@"rest_thumbnail"]];
    [self.imgRest setImageWithURL:agentImageURL];
    self.lblRestName.text = [self.dictSelectedRestaurant objectForKey:@"rest_name"];
    self.lblRestAddress.text = [self.dictSelectedRestaurant objectForKey:@"rest_address"];
    
    NSURL *logoImageURL = [NSURL URLWithString:[self.dictSelectedRestaurant objectForKey:@"rest_logo"]];
    [self.imgLogo setImageWithURL:logoImageURL];
    self.imgLogo.layer.cornerRadius= self.imgLogo.frame.size.width / 2;
    self.imgLogo.layer.masksToBounds = YES;
    self.imgLogo.clipsToBounds = YES;
}

#pragma mark GET CATEGORIES

-(void) getRestaurantMenuCategories
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictParams = @{@"rest_id":@"1"};
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager getRestaurantMenuCategories:dictParams];
}


-(void) didGetRestaurantMenuCategoriesSuccessfully:(RapidzzBaseManager *)manager
{
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.arrCategories = [self.manager.data objectForKey:@"data"];
        
        int gap = 10;
        int xValue;
        int labelWidth = 0;
        int lastEndingPoint = gap;
        
        for (int i = 0; i< self.arrCategories.count; i++)
        {
            xValue = (labelWidth + gap) * i;
            
            // ADD CLOSE BUTTON
            UIButton *catButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [catButton addTarget:self
                            action:@selector(buttonCalled:)
                  forControlEvents:UIControlEventTouchUpInside];
            catButton.tag = i;
            [catButton setTitle:[[[self.arrCategories objectAtIndex:i] objectForKey:@"cat_name"] uppercaseString] forState:UIControlStateNormal];
            
            labelWidth = (int)[[[self.arrCategories objectAtIndex:i] objectForKey:@"cat_name"] length] * 10;
            catButton.frame = CGRectMake(lastEndingPoint, 5, labelWidth, 22);
            catButton.tag = i+1;//[[[self.arrCategories objectAtIndex:i] objectForKey:@"cat_id"] intValue];
            
            //add line under categories
            UIImageView *imgLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line-red.png"]];
            imgLine.frame = CGRectMake(lastEndingPoint, 25, labelWidth, 1);
            imgLine.tag = i+1;//[[[self.arrCategories objectAtIndex:i] objectForKey:@"cat_id"] intValue] + 100;
            imgLine.hidden = YES;
            if (i == 0)
            {
                //catButton.backgroundColor = [UIColor blackColor];
                imgLine.hidden = NO;
                preCatButton = catButton;
            }
            
            [catButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            catButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:0];
            
            // SET SELECTED CAT BACKGROUND COLOUR
//            if(i == 0)
//                catButton.backgroundColor = [UIColor redColor];
            [self.scrCatgories addSubview:catButton];
            [self.scrCatgories addSubview:imgLine];
            
            lastEndingPoint = lastEndingPoint + labelWidth + gap;
        }
        
        [self.scrCatgories setContentSize:CGSizeMake(lastEndingPoint + 26, 25)];
        [AppDelegate singleton].selectedCatId = [[self.arrCategories objectAtIndex:0] objectForKey:@"cat_id"];
        [self pagerSettings];
    }
}

-(void) didGetRestaurantMenuCategoriesFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(IBAction)btnYourorder:(id)sender
{
    [self performSegueWithIdentifier:@"MenuToYourorder" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YourorderViewController *detailVC = [segue destinationViewController];
    detailVC.dictSelectedRestaurant = self.dictSelectedRestaurant;
}

-(IBAction)buttonCalled:(id)sender
{
    
    //    for (UIView *subview in self.scrCatgories)
    //    {
    //        subview.backgroundColor = [UIColor clearColor];
    //    }
    UIButton *btnClicked = (UIButton *)sender;
    int tag =(int) btnClicked.tag;
    [AppDelegate singleton].selectedCatId = [[self.arrCategories objectAtIndex:tag-1]objectForKey:@"cat_id"];
    NSLog(@"Category Button id = %@", [AppDelegate singleton].selectedCatId);
    
    
    pagerIndex = tag;
    NSArray *subviews = [self.scrCatgories subviews];
    for(int i=0;i<subviews.count;i++)
    {
        UIView *view = [subviews objectAtIndex:i];
        view.backgroundColor = [UIColor clearColor];
        if ([view isKindOfClass:[UIImageView class]])
        {
            if(view.tag == tag)
            {
                view.hidden = NO;
            }
            else
            {
                view.hidden = YES;
            }
        }
        
    }
    //btnClicked.backgroundColor = [UIColor blackColor];
    
    
    
    
    
    [self pagerSettings];
}



#pragma mark PAGER METHODS AND DELEGATES

-(void) pagerSettings
{
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    //[[self.pageController view] setFrame:[[self view] bounds]];
    
    //int device = [self CheckDevice];
    
    //self.pageController.view.backgroundColor = [UIColor blackColor];
    //self.view.backgroundColor = [UIColor redColor];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [[self.pageController view] setFrame:CGRectMake(0, 255, 320, 314)];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        [[self.pageController view] setFrame:CGRectMake(0, 260, 375, 407)];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        [[self.pageController view] setFrame:CGRectMake(0, 265, 414, 470)];
    }
    

    //[[self.pageController view] setFrame:CGRectMake(0, 280, 375, 400)];
    pagerChildViewController *initialViewController;
    if(pagerStartFirstTime == YES)
    {
        
        initialViewController = [self viewControllerAtIndex:0];
        pagerStartFirstTime = NO;
    }
    else
    {
        initialViewController = [self viewControllerAtIndex:pagerIndex-1];
    }
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    //[initialViewController.btnPlaceOrder addTarget:self action:@selector(placeOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button addTarget:self
     action:@selector(placeOrder:)
     forControlEvents:UIControlEventTouchUpInside];
     //[button setTitle:@"Show View" forState:UIControlStateNormal];
     UIImage *btnImage = [UIImage imageNamed:@"btn-your-order.png"];
     [button setImage:btnImage forState:UIControlStateNormal];
    
    
    //ADD SERVICE REQUEST BUTTON
    UIButton *btnServiceRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnServiceRequest addTarget:self
               action:@selector(showServiceRequestPopup:)
     forControlEvents:UIControlEventTouchUpInside];
    [btnServiceRequest setTitle:@"Service Request" forState:UIControlStateNormal];
   btnServiceRequest.titleLabel.font = [UIFont systemFontOfSize:12];
    
    //[initialViewController.btnPlaceOrder addTarget:self action:@selector(placeOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
        float X_Co = (self.view.frame.size.width - 122)/2;
        float Y_Co = self.view.frame.size.height - 50;
    
        _lblItemCount = [[UILabel alloc] init];
        [_lblItemCount setFrame:CGRectMake(X_Co, Y_Co - 18, 122, 50)];
        _lblItemCount.text = @"";
        _lblItemCount.textAlignment = NSTextAlignmentCenter;
        _lblItemCount.textColor = [UIColor whiteColor];
        [_lblItemCount setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    
    [button setFrame:CGRectMake(X_Co, Y_Co, 122, 50)];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        btnServiceRequest.frame = CGRectMake(X_Co-100, Y_Co+10, 100.0, 30.0);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        btnServiceRequest.frame = CGRectMake(X_Co-120, Y_Co+10, 100.0, 30.0);

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        btnServiceRequest.frame = CGRectMake(X_Co-140, Y_Co+10, 100.0, 30.0);

    }
    
    [self.btnYourOrder setFrame:CGRectMake(X_Co, Y_Co, 122, 50)];
    
        [self.view addSubview:btnServiceRequest];
    [self.view addSubview:button];
    [self.view addSubview:_lblItemCount];
    
}
- (pagerChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    _pageController.delegate = self;
    
    
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    pagerChildViewController* childViewController = [sb instantiateViewControllerWithIdentifier:@"pagerChildViewController"];
    
    childViewController.index = index;
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(pagerChildViewController *)viewController index];
    
    if (index == 0)
    {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    [AppDelegate singleton].selectedCatId = [[self.arrCategories objectAtIndex:index] objectForKey:@"cat_id"];
    
    
    NSLog(@"pager Index: %lu", (unsigned long)index);
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(pagerChildViewController *)viewController index];
    
    index++;
    
    if (index == self.arrCategories.count)
    {
        return nil;
    }
    
    NSLog(@"pager Index: %lu", (unsigned long)index);
    
    [AppDelegate singleton].selectedCatId = [[self.arrCategories objectAtIndex:index] objectForKey:@"cat_id"];
    return [self viewControllerAtIndex:index];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if(completed){
        
        pagerChildViewController *enlarge =[self.pageController.viewControllers lastObject];
        //        self.enlargePhotoPageControl.currentPage =  enlarge.pageIndex;
        
        //pagerChildViewController *pc;
        //pageIndex =(int) [[self.arrCategories objectAtIndex:enlarge.index-1]objectForKey:@"cat_id"] ;
        pageIndex = (int)enlarge.index;
        
        NSArray *subviews = [self.scrCatgories subviews];
        for(int i=0;i<subviews.count;i++)
        {
            UIView *view = [subviews objectAtIndex:i];
            view.backgroundColor = [UIColor clearColor];
            if ([view isKindOfClass:[UIImageView class]])
            {
                if(view.tag == pageIndex+1)
                {
                    view.hidden = NO;
                }
                else
                {
                    view.hidden = YES;
                }
            }
            if([view isKindOfClass:[UIButton class]])
            {
                if(view.tag == pageIndex+1)
                {
                    //view.backgroundColor = [UIColor blackColor];
                }
                else
                {
                    view.backgroundColor = [UIColor clearColor];
                }
            }
        }
    }
}

// PLACE ORDER POPUP

#pragma mark - SEND ORDER TO KITCHEN

- (IBAction)placeOrder:(id)sender
{
//    if ([AppDelegate singleton].arrCurrOrder.count > 0)
//    {
        self.alertView = [[CustomIOSAlertView alloc] init];
        self.alertView.tag = 1001;
        //[self.alertView setFrame:CGRectMake(0, 0, 302, 430)];
        [self.alertView setContainerView:[self createPopup:0]];
        
        
        // Modify the parameters
        [self.alertView setButtonTitles:nil];
        [self.alertView setDelegate:self];
        [self.alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [self.alertView show];
//    }
//    else
//    {
//        [[AppDelegate singleton] showAlertwith:nil andMessage:@"There is no dish in the cart"];
//    }
}

- (UIView *) createPopup: (int) index
{
    UIView *demoView;
    _objYourderView = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceorderVC"];
    //float Y_Co = self.view.frame.size.height - 430;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 302, 430)];
    _objYourderView.view.frame = CGRectMake(0, 0, 302, 430);
    
    //ADD BUTTONS METHODS
    [_objYourderView.btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_objYourderView.btnDone addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];

    
    [demoView addSubview:_objYourderView.view];
    return demoView;
}

//SAVE AND CANCEL BUTTON
-(IBAction)btnCancel:(id)sender
{
    //[self.placeOrderView removeFromSuperview];
    [self.alertView close];
    
}

-(IBAction)btnDone:(id)sender
{
    if ([AppDelegate singleton].arrCurrOrder.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Are you sure you want to submit this order ?"
                                                   delegate:self
                                          cancelButtonTitle:@"YES"
                                          otherButtonTitles:@"NO",nil];
        [alert show];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:@"No dish to submit please press cancel"];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        //[self.placeOrderView removeFromSuperview];
        [self.alertView close];
        [_objYourderView saveOrder];
        delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.btnRightSlider setTitle:[NSString stringWithFormat:@"$%.02f",delegate.totalBillAmount] forState:UIControlStateNormal];
        
//        pagerChildViewController *initialViewController = [self viewControllerAtIndex:0];
//        initialViewController.lblItemsCount.text = @"";
        
    }
}



# pragma mark   RIGHT SLIDER

// PLACE ORDER POPUP

#pragma mark - SEND ORDER TO KITCHEN

- (IBAction)rightSlider:(id)sender
{
    
    self.rightSliderView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.parentViewController.view.bounds.size.width, self.parentViewController.view.bounds.size.height)];
        
    //self.alertView.frame = CGRectMake(0, 50, 302, 430);
    [self.rightSliderView addSubview:[self createRightSlider:0]];
    self.rightSliderView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.rightSliderView];
}

- (UIView *) createRightSlider: (int) index
{
    UIView *demoView;
    _objYourderView = [self.storyboard instantiateViewControllerWithIdentifier:@"rightSliderVC"];
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.parentViewController.view.bounds.size.width, self.parentViewController.view.bounds.size.height)];
    _objYourderView.view.frame = CGRectMake(0, 0, self.parentViewController.view.bounds.size.width, self.parentViewController.view.bounds.size.height);
    
    //ADD BUTTONS METHODS
    [_objYourderView.btnCancel addTarget:self action:@selector(closeRightSlider:) forControlEvents:UIControlEventTouchUpInside];
    [_objYourderView.btnDone addTarget:self action:@selector(moveToPayScreen:) forControlEvents:UIControlEventTouchUpInside];
    //[_objYourderView.btnCancel setTitle:[NSString stringWithFormat:@"%.02f",[AppDelegate singleton].totalAmount] forState:UIControlStateNormal];
    [demoView addSubview:_objYourderView.view];
    return demoView;
}


//SAVE AND CANCEL BUTTON
-(IBAction)closeRightSlider:(id)sender
{
    [self.rightSliderView removeFromSuperview];
}

-(IBAction)moveToPayScreen:(id)sender
{
    [self.rightSliderView removeFromSuperview];
    [self performSegueWithIdentifier:@"sliderToPayment" sender:self];
}


// ADD SERVICE REQUEST
- (IBAction)showServiceRequestPopup:(id)sender
{
    
    // Here we need to pass a full frame
    serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,300,400)];
    emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 450, 670)];
    
    self.alertView = [[CustomIOSAlertView alloc] init];
//    UIAlertView * alert = [ [ UIAlertView alloc ] initWithTitle:@"Alert" message:@"Alert"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
    
    self.alertView.transform = CGAffineTransformTranslate( self.alertView.transform, 0.0, 100.0 );
    
    self.alertView = [[CustomIOSAlertView alloc] initWithFrame:CGRectMake(0, 0, 300, 550)];

    self.alertView.tag = 1002;
    UIButton *btnClicked = (UIButton *)sender;
    int index = (int)btnClicked.tag;
    
    [self.alertView setContainerView:[self createServiceRequestPopup:index]];
    
    // Modify the parameters
    [self.alertView setButtonTitles:nil];
    //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", nil]];
    [self.alertView setDelegate:self];
    
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
  
    
    [serviceView addSubview:[self createServiceRequestPopup:index]];
    
    serviceView.frame = CGRectMake( 40,250, serviceView.frame.size.width, serviceView.frame.size.height );
  emptyView.frame = CGRectMake( 0, 0, serviceView.frame.size.width+300, serviceView.frame.size.height+300 );
    emptyView.backgroundColor = [UIColor redColor];
    
    emptyView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];

    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        serviceView.frame = CGRectMake(10,150, serviceView.frame.size.width, serviceView.frame.size.height);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        serviceView.frame = CGRectMake(40,250, serviceView.frame.size.width, serviceView.frame.size.height);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        serviceView.frame = CGRectMake(57,300, serviceView.frame.size.width,serviceView.frame.size.height);
    }
    
    
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:emptyView];
    
    
    
    [emptyView addSubview:serviceView];
    
    
     //And launch the dialog
    
     [self.alertView show];
}


- (UIView *) createServiceRequestPopup: (int) index
{
    UIView *demoView;
    self.objServiceView = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceRequest"];
    //float Y_Co = self.view.frame.size.height - 430;
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300  , 400)];
    self.objServiceView.view.frame = CGRectMake(0, 0, 300, 400);
    
    //ADD BUTTONS METHODS
    [self.objServiceView.btnDone addTarget:self action:@selector(btnDone_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    //  [self.cardPopUp.btnDone addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [demoView addSubview:self.objServiceView.view];
    return demoView;
}


-(IBAction)btnDone_Tapped:(id)sender
{
     [self.alertView close];
    serviceView.hidden = YES;
    emptyView.hidden = YES;
}


//THIS IS FOR PAGER DOTS, WE DO NOT NEED PAGE DOTS

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    // The number of items reflected in the page indicator.
//    return self.arrCategories.count;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    // The selected item reflected in the page indicator.
//    return 0;
//}



-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
