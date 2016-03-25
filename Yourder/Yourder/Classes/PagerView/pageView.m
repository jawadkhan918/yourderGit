
#import "pageView.h"

@interface pageView ()
{
    int pagerIndex;
    int pageIndex;
}

@end

@implementation pageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Create the data model
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.pageTitles= @[@"Yourder", @"Order", @"Split",@"Pay"];
    self.pageSubTitles= @[@"Order.Split.Pay", @"Browse the entire menu and order anything you like instantly", @"Split any item with anyone on the table as you order,just send them a request",@"Pay the bill at any time abd leave when you like,Everything is already split so no need to worry about it.Dont forget to tip"];
    
    self.pageImages = @[@"bg-Yourder_login.png", @"bg-yourder_login2.png", @"bg-yourder_login3.png",@"bg-yourder_login4.png"];

    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0);
    [self.pageViewController.view setBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    
    self.btnLogin.layer.borderColor=[[UIColor colorWithRed:18.0f/255.0f green:130.0f/255.0f blue:107.0f/255.0f alpha:1.0] CGColor];
    self.btnLogin.layer.borderWidth = 2.5f;
    self.btnLogin.layer.cornerRadius = 20; // this value vary as per your desire
    self.btnLogin.clipsToBounds = YES;
    
    self.btnSignup.layer.borderColor=[[UIColor colorWithRed:18.0f/255.0f green:130.0f/255.0f blue:107.0f/255.0f alpha:1.0] CGColor];
    self.btnSignup.layer.borderWidth = 2.5f;
    self.btnSignup.layer.cornerRadius = 20; // this value vary as per your desire
    self.btnSignup.clipsToBounds = YES;
    
    [self addsubViews];
}
-(void)addsubViews
{
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin addTarget:self
                 action:@selector(btnLogin:)
       forControlEvents:UIControlEventTouchUpInside];
    btnLogin.frame = CGRectMake(13.0,530.0, 140.0, 31.0);
    UIImage *btnlogin = [UIImage imageNamed:@"btn-login.png"];
    [btnLogin setImage:btnlogin forState:UIControlStateNormal];
    [self.view addSubview:btnLogin];
    
    UIButton *btnSignup = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSignup addTarget:self
                  action:@selector(btnSignUp:)
        forControlEvents:UIControlEventTouchUpInside];
    btnSignup.frame = CGRectMake(170.0,530.0, 140.0, 31.0);
    UIImage *btnImage = [UIImage imageNamed:@"btn-signup.png"];
    [btnSignup setImage:btnImage forState:UIControlStateNormal];
    [self.view addSubview:btnSignup];
    
    for(int i=0;i<4;i++)
    {
        int x;
        x= 125+i*20;
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 500, 10, 10)];
        NSLog(@"%i",x);
        fromLabel.numberOfLines = 1;
        fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
        fromLabel.adjustsFontSizeToFitWidth = YES;
        fromLabel.minimumScaleFactor = 10.0f/12.0f;
        fromLabel.clipsToBounds = YES;
        fromLabel.backgroundColor = [UIColor whiteColor];
        fromLabel.textAlignment = NSTextAlignmentLeft;
       fromLabel.layer.cornerRadius= fromLabel.frame.size.width / 2;
        fromLabel.layer.masksToBounds = YES;
        fromLabel.clipsToBounds = YES;

        fromLabel.tag = i;
        if(i == 0)
            fromLabel.backgroundColor = [UIColor redColor];
        
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            btnLogin.frame = CGRectMake(13.0,530.0, 140.0, 31.0);
            btnSignup.frame = CGRectMake(170.0,530.0, 140.0, 31.0);
            fromLabel.frame = CGRectMake(x, 500, 10, 10);
            
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 667)
        {
           btnLogin.frame = CGRectMake(17.0,620.0, 160.0, 35.0);
            btnSignup.frame = CGRectMake(195.0,620.0, 160.0, 35.0);
            fromLabel.frame = CGRectMake(x+23, 600, 10, 10);
           
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 736)
        {
            btnLogin.frame = CGRectMake(13.0,530.0, 140.0, 31.0);
            fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 500, 10, 10)];
        }
        
        [self.view addSubview:fromLabel];
    }
    
    

    
}

-(IBAction)btnLogin:(id)sender
{
    [self performSegueWithIdentifier:@"loginViewController" sender:self];
}
-(IBAction)btnSignUp:(id)sender
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    self.pageViewController.delegate = self;

    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.subTitleText = self.pageSubTitles[index];
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
       index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
      index++;
    
   
    
    
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}



- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if(completed){
        
          PageContentViewController *enlarge =[self.pageViewController.viewControllers lastObject];
       
        pageIndex = (int)enlarge.pageIndex;
    
        
        
        NSArray *subviews = [self.view subviews];
        for(int i=0;i<subviews.count;i++)
        {
            UIView *view = [subviews objectAtIndex:i];
            view.backgroundColor = [UIColor clearColor];
            if ([view isKindOfClass:[UILabel class]])
            {
                if(view.tag == pageIndex)
                {
                    view.backgroundColor = [UIColor redColor];
                }
                else
                {
                    view.backgroundColor = [UIColor whiteColor];
                }
            }
            
        }
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles  count];
}




@end
