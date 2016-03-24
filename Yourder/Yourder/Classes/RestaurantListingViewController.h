//
//  RestaurantListingViewController.h
//  Yourder
//
//  Created by Rapidzz on 16/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RestaurantTableViewCell.h"
#import "RestaurantDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "IQDropDownTextField.h"
#import <CoreLocation/CoreLocation.h>


@interface RestaurantListingViewController : UIViewController < MKAnnotation, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, RapidzzUserManagerDelegate, UISearchBarDelegate, UITextFieldDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *arrRestaurants;
@property (strong, nonatomic) NSMutableArray *arrSearchResturants;
@property (strong, nonatomic) MKMapView *myMap;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tblRestaurants;
@property (strong, nonatomic) RapidzzUserManager *manager;
//@property (weak, nonatomic) IBOutlet UISearchBar *txtSearch;

@property (weak, nonatomic) IBOutlet UILabel *txtSearch;


@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeView;
@property (weak, nonatomic) IBOutlet UIButton *slidebarButton;

//SEARCH FIELDS
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtDistance;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtState;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtZipCode;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtCousine;

//SEARCH VARIABLES
@property (strong, nonatomic) NSMutableArray *arrdistance;
@property (strong, nonatomic) NSArray *arrState;
@property (strong, nonatomic) NSArray *arrZipcode;
@property (strong, nonatomic) NSArray *arrCousine;
@property (retain, nonatomic) NSMutableArray *arrCountries;




@end
NSString *city;
