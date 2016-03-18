//
//  RestaurantListingViewController.m
//  Yourder
//
//  Created by Rapidzz on 16/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import "RestaurantListingViewController.h"
#import <MapKit/MapKit.h>
#import "Constants.h"


@interface RestaurantListingViewController ()
{
    int imgid;
    NSDictionary *dictSelectedRestaurant;
    BOOL filterViewHidden;
    BOOL isFiltered;
    NSArray *arrCousine;
    int pageCount;
    int searchPageCount;
    UIView *footerView;
    NSString *strLat;
    NSString *strLong;
    

}

@end


@implementation RestaurantListingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //FOR DROP DOWN
    

    
    arrCousine = [[NSArray alloc] initWithObjects:@"Chinese",@"Indian",@"Malay",@"Others", nil];
    
    
    
    self.txtCousine.itemList = arrCousine;
    self.txtDistance.itemList = arrCousine;
    self.txtState.itemList = arrCousine;
    self.txtZipCode.itemList = arrCousine;
    
    [self addToolBarToPickerView:self.txtCousine];
    [self addToolBarToPickerView:self.txtZipCode];
    [self addToolBarToPickerView:self.txtState];
    [self addToolBarToPickerView:self.txtDistance];
    
    self.arrRestaurants = [[NSMutableArray alloc] init];
    
    //SLIDEBAR VIEW
    self.slidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //FILTER VIEW
    filterViewHidden = YES;
    self.filterView.alpha = 0;
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 23)];
    logoImage.image = [UIImage imageNamed:@"logo-nav.png"];
    self.navigationItem.titleView = logoImage;
    
    //RIGHT CORNER BUTTONss
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 72.0f, 32.0f)];
    [btn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"btn-red.png"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = eng_btn;
    
    [self getCurrentLcoation];
    [self searchFields];
    
    // add Map
    //self.myMap = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.myMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height)];
    self.myMap.showsUserLocation = YES;
    [self.myMap setShowsUserLocation:YES];
    self.myMap.mapType = MKMapTypeStandard;
    self.myMap.delegate = self;
    [self.view addSubview:self.myMap];
    self.myMap.hidden = YES;
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.txtSearch.delegate = self;
    
    pageCount = 0;
    searchPageCount = 0;
    
    
}

-(void)addFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *loadMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadMore addTarget:self
                 action:@selector(loadmoreResturants:)
       forControlEvents:UIControlEventTouchUpInside];
    [loadMore setBackgroundImage:[UIImage imageNamed:@"btn-red.png"]
                        forState:UIControlStateNormal];
    
    [loadMore setTitle:@"Load More" forState:UIControlStateNormal];
    loadMore.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        loadMore.frame = CGRectMake(110,20, 100,30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        loadMore.frame = CGRectMake(140,20, 100,30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        loadMore.frame = CGRectMake(157,20, 100,30);
    }
    
    [footerView addSubview:loadMore];
    
    self.tblRestaurants.tableFooterView = footerView;
}



-(IBAction)loadmoreResturants:(id)sender
{
    if(isFiltered == NO)
    {
        pageCount++;
        [self getRestaurantList];
    }
    else
    {
        [self searchRestaurant];
    }
    
}

-(void) searchFields
{
    self.arrRestaurants = [[NSMutableArray alloc] init];
    self.arrCousine = [[NSArray alloc] init];
    self.arrdistance = [[NSMutableArray alloc] init];
    self.arrState = [[NSArray alloc] init];
    self.arrZipcode = [[NSArray alloc] init];
    [self getUSAStatesFromTextFile];
    self.arrCousine = [[NSArray alloc] initWithObjects:@"Chinese",@"Indian",@"Malay",@"Italian",@"Punjabi", nil];
    self.arrdistance = [[NSMutableArray alloc] init];
    self.arrState = [[NSArray alloc] initWithObjects:@"10",@"20",@"30",@"50", nil];
    self.arrZipcode = [[NSArray alloc] initWithObjects:@"5400",@"5500",@"5600",@"5700",@"5800", nil];
    
    self.txtCousine.itemList = self.arrCousine;
    [self addToolBarToPickerView:self.txtCousine];
    self.txtDistance.itemList = _arrState;
    [self addToolBarToPickerView:self.txtDistance];
    self.txtZipCode.itemList = self.arrZipcode;
    [self addToolBarToPickerView:self.txtZipCode];
    
    
    //PLACE HOLDERS COLOR CHANGE TO RIGHT
    UIColor *whiteColor = [UIColor whiteColor];
    self.txtDistance.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Distance"
     attributes:@{NSForegroundColorAttributeName:whiteColor}];
    
    self.txtCousine.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Cousine"
     attributes:@{NSForegroundColorAttributeName:whiteColor}];
    
    self.txtState.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"State/City"
     attributes:@{NSForegroundColorAttributeName:whiteColor}];
    
    self.txtZipCode.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"ZipCode"
     attributes:@{NSForegroundColorAttributeName:whiteColor}];
    
    self.txtSearch.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@" Search restaurant"
     attributes:@{NSForegroundColorAttributeName:whiteColor}];
    
    
}


// PARSE AND BIND USA States FROM TEXT FILE
-(void) getUSAStatesFromTextFile
{
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"USAStatesNames" ofType:@"txt"];
    NSError *errorReading;
    
    NSString* content = [[NSString alloc] initWithContentsOfFile:filePath encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsHebrew) error:&errorReading];
    
    NSArray *arrCountryNames = [content componentsSeparatedByString:@"<item>"];
    NSMutableArray *arrCountries = [[NSMutableArray alloc] init];
    arrCountries = (NSMutableArray *)arrCountryNames;
    
    self.arrdistance = [[NSMutableArray alloc] init];
    NSString *str;
    for (int i = 1;i <=[arrCountryNames count]-1;i++)
    {
        str = [[arrCountries objectAtIndex:i] stringByReplacingOccurrencesOfString:@"</item>" withString:@""];
        [self.arrdistance addObject:str];
        NSLog(@"Count is : %i", i);
    }
    
    self.txtState.itemList = self.arrdistance;
    [self addToolBarToPickerView:self.txtState];
    
}

-(void) addToolBarToPickerView : (IQDropDownTextField *) textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    textField.inputAccessoryView = toolbar;
}
-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}

-(void) setUISearchField
{
    for (UIView *subView in self.txtSearch.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here
                searchBarTextField.textColor = [UIColor blackColor];
                
                break;
            }
        }
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) getRestaurantList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dict = @{@"page":[NSString stringWithFormat:@"%i",pageCount],@"rest_lat":strLat,@"rest_long":strLong};
    [self.manager getRestaurantList:dict];
}

-(void) didGetRestaurantListSuccessfully:(RapidzzBaseManager *)manager
{
    [self addFooterView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        [self.arrRestaurants addObjectsFromArray:[self.manager.data objectForKey:@"data"]];
        [self.tblRestaurants reloadData];
        
        [self dropPins];
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
        [self.tblRestaurants reloadData];
        self.tblRestaurants.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tblRestaurants.sectionFooterHeight = 0.0;
    }
    //SET TABLE FOOTER
    
}

-(void) didGetRestaurantListFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Failed! Please try again"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


# pragma mark - get current location

-(void) getCurrentLcoation
{
    [self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager requestAlwaysAuthorization];
    
    if (nil == self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.myMap.centerCoordinate = self.myMap.userLocation.location.coordinate;
    
    MKUserLocation *userLocation = self.myMap.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 300, 300);
    [self.myMap setRegion:region animated:NO];
    
    self.myMap.showsUserLocation = YES; 
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        [_locationManager requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
    {
        //_locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"using LocationManager:current location latitude = %f, longtitude = %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    strLat = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    strLong = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
    [self getRestaurantList];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Assigning the last object as the current location of the device
    
    
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"didUpdateToLocation:Latitude :  %f", currentLocation.coordinate.latitude);
    NSLog(@"didUpdateToLocation:Longitude :  %f", currentLocation.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    self.myMap.showsUserLocation = YES;
    
    //[self.myMap setCenterCoordinate:self.myMap.userLocation.location.coordinate animated:YES];

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.myMap setShowsUserLocation:YES];
    [self.myMap setMapType:MKMapTypeStandard];
    
    MKCoordinateRegion region;
    
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    
    region.center = location;
    region.span.longitudeDelta = 0.2;
    region.span.latitudeDelta = 0.2;
    [self.myMap setRegion:region animated:YES];
    [self.myMap setDelegate:self];
}


# pragma mark - drop pins

-(void) dropPins
{
    CLLocationCoordinate2D  ctrpoint;
    
    for (int i = 0; i < self.arrRestaurants.count; i++)
    {
        NSDictionary *dict = [self.arrRestaurants objectAtIndex:i];
        ctrpoint.latitude = [[dict objectForKey:@"rest_lat"] doubleValue];
        ctrpoint.longitude = [[dict objectForKey:@"rest_long"] doubleValue];
        MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        pin.coordinate = ctrpoint;
        pin.title = [dict objectForKey:@"rest_name"];
        pin.subtitle = [dict objectForKey:@"rest_address"];
        [self.myMap addAnnotation:pin];
    }
}


- (void)removeAllPinsButUserLocation1
{
    id userLocation = [self.myMap userLocation];
    [self.myMap removeAnnotations:[self.myMap annotations]];
    
    if ( userLocation != nil ) {
        [self.myMap addAnnotation:userLocation]; // will cause user location pin to blink
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = nil;
    if(annotation !=self.myMap.userLocation)
    {
        
        view = (MKAnnotationView *)
        [self.myMap dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        if(nil == view)
        {
            view = [[MKAnnotationView alloc]
                     initWithAnnotation:annotation reuseIdentifier:@"identifier"]
                    ;
        }
        
        // Add button on pin
        UIButton *btnOnPin = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOnPin addTarget:self
                     action:@selector(performSequeOnMap)forControlEvents:UIControlEventTouchUpInside];
        [btnOnPin setTitle:@"" forState:UIControlStateNormal];
        [btnOnPin setImage:[UIImage imageNamed:@"icon-arrow-grey.png"] forState:UIControlStateNormal];
        
        btnOnPin.frame = CGRectMake(0, 0, 30, 30);
        view.rightCalloutAccessoryView=btnOnPin;
        
        for (int i = 0; i<self.arrRestaurants.count; i++)
        {
            if ([[annotation title] isEqualToString:[[self.arrRestaurants objectAtIndex:i] objectForKey:@"rest_name"]])
            {
                //RESTAURANT ICON IN POPUP VIEW
                UIImageView *restLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 51, 51)];
                NSURL *agentImageURL = [NSURL URLWithString:[[self.arrRestaurants objectAtIndex:i] objectForKey:@"rest_logo"]];
                
                restLogo.layer.cornerRadius= restLogo.frame.size.width / 2;
                restLogo.layer.masksToBounds = YES;
                restLogo.clipsToBounds = YES;
                [restLogo setImageWithURL:agentImageURL];
                view.leftCalloutAccessoryView = restLogo;
                
                break;
            }
        }
        
        view.enabled = YES;
        view.canShowCallout = YES;
        view.multipleTouchEnabled = NO;
        //view.animatesDrop = YES;
        view.image = [UIImage imageNamed:@"pin-map.png"];
        
    }       
    return view;
}
-(void) performSequeOnMap
{
    NSIndexPath *indexPath;
    dictSelectedRestaurant = [self.arrRestaurants objectAtIndex:indexPath.row];
    [AppDelegate singleton].dictSelectedRestaurant = dictSelectedRestaurant;
    [self performSegueWithIdentifier:@"RestaurantlistingToDetail" sender:self];
}

# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrRestaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[RestaurantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
    }
    
    imgid++;
    if (imgid > 5)
    {
        imgid = 1;
    }
    
    NSDictionary *dict = [self.arrRestaurants objectAtIndex:indexPath.row];
    cell.lblRestaurantName.text = [dict objectForKey:@"rest_name"];
    cell.lblRestaurantAddress.text = [dict objectForKey:@"rest_address"];
    cell.lblCaisuineType.text = [[dict objectForKey:@"rest_type"] stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
    
    cell.ratingView.starSize = CGSizeMake(15.0, 15.0);
    cell.ratingView.rating = [[dict objectForKey:@"rating_value"] floatValue];
    cell.lblRatingValue.text = [NSString stringWithFormat:@"%.01f", [[dict objectForKey:@"rating_value"] floatValue]];
    
    if ([[dict objectForKey:@"rest_thumbnail"] length] > 10)
    {
        NSURL *agentImageURL = [NSURL URLWithString:[dict objectForKey:@"rest_thumbnail"]];
        [cell.bigImage setImageWithURL:agentImageURL];
    }
    else
    {
        cell.bigImage.image = [UIImage imageNamed:@"no-photo-rest-i6.png"];
    }
    
    
    NSURL *logoImageURL = [NSURL URLWithString:[dict objectForKey:@"rest_logo"]];
    [cell.imgRetaurantLogo setImageWithURL:logoImageURL];
    cell.imgRetaurantLogo.layer.cornerRadius= cell.imgRetaurantLogo.frame.size.width / 2;
    cell.imgRetaurantLogo.layer.masksToBounds = YES;
    cell.imgRetaurantLogo.clipsToBounds = YES;
    cell.ratingView.rating = [[dict objectForKey:@"rating_value"] floatValue];
    

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     RestaurantTableViewCell *cell = (RestaurantTableViewCell *)[self.tblRestaurants cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    dictSelectedRestaurant = [self.arrRestaurants objectAtIndex:indexPath.row];
    [AppDelegate singleton].dictSelectedRestaurant = dictSelectedRestaurant;
    [self performSegueWithIdentifier:@"RestaurantlistingToDetail" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RestaurantDetailViewController *detailVC = [segue destinationViewController];
    detailVC.dictSelectedRestaurant = dictSelectedRestaurant;
}


-(void) searchRestaurant
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // NSString *trimState = [self.txtState.text stringByTrimmingCharactersInSet:
                               //[NSCharacterSet whitespaceCharacterSet]];
    
    NSDictionary *dict = @{@"keyword":self.txtSearch.text,
                           @"page":[NSString stringWithFormat:@"%i",searchPageCount],
                           //  @"rest_lat":strLat,@"rest_long":strLong,
                           // @"restrad":self.txtDistance.text,
                           @"rest_type":self.txtCousine.text,
                           @"rest_city":self.txtState.text,
                           @"rest_postcode":self.txtZipCode.text};
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    [self.manager searchRestaurant:dict];}


-(void) didSearchRestaurantSuccessfully:(RapidzzBaseManager *)manager
{
    [self addFooterView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dictResult = manager.data;
    if ([[dictResult objectForKey:@"status"] integerValue] == 0)
    {
        [self.arrRestaurants addObjectsFromArray:[self.manager.data objectForKey:@"data"]];
        [self.tblRestaurants reloadData];
        [self removeAllPinsButUserLocation1];
        [self dropPins];
        
    }
    else
    {
        [[AppDelegate singleton] showAlertwith:nil andMessage:[dictResult objectForKey:@"message"]];
        [self.tblRestaurants reloadData];
         self.tblRestaurants.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
         self.tblRestaurants.sectionFooterHeight = 0.0;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //SET TABLE FOOTER
    
}

-(void) didSearchRestaurantfailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(IBAction)showHideFilters:(id)sender
{
    self.filterView.hidden =NO;
    if (filterViewHidden == YES)
    {
        self.myMap.frame = CGRectMake(0, 162, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.5
                     animations:^{
                         self.filterView.alpha = 1;
                     }];
        filterViewHidden = NO;
    }
    else
    {
        self.myMap.frame = CGRectMake(0, 99, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.filterView.alpha = 0;
                         }];
        filterViewHidden = YES;
    }
}


-(IBAction)changeView:(id)sender
{
    if (self.myMap.hidden)
    {
        self.myMap.hidden = NO;
        self.tblRestaurants.hidden = YES;
        [self.btnChangeView setImage:[UIImage imageNamed:@"btn-list"] forState:UIControlStateNormal];
    }
    else
    {
        self.myMap.hidden = YES;
        self.tblRestaurants.hidden = NO;
        [self.btnChangeView setImage:[UIImage imageNamed:@"btn-map"] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(IBAction)searchRestaurant:(id)sender
{
    if(self.txtSearch.text.length == 0 && self.txtCousine.text.length == 0 && self.txtState.text.length == 0 && self.txtZipCode.text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        self.arrSearchResturants = [[NSMutableArray alloc]init];
        searchPageCount = 0;
    }
    
    [self.txtSearch resignFirstResponder];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(isFiltered == NO )
    {
        pageCount = 0;
        searchPageCount = 0;
        self.arrRestaurants = [[NSMutableArray alloc]init];
        [self getRestaurantList];
    }
    else
    {
        self.arrRestaurants = [[NSMutableArray alloc]init];
        [self searchRestaurant];
        searchPageCount++;
    }
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(self.txtSearch.text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        self.arrSearchResturants = [[NSMutableArray alloc]init];
        searchPageCount = 0;
    }
    
    
    return YES;
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (targetContentOffset->y/4>0){
        self.filterView.hidden = YES;
        
    }
    if (targetContentOffset->y/4<0){
        self.filterView.hidden = NO;
        
    }
    filterViewHidden = YES;
    
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
