//
//  RatingViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 17/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "RatingViewController.h"

@interface RatingViewController ()

@end

@implementation RatingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ratingView.maxRating = 5;
    self.ratingView.starSize = CGSizeMake(25.0, 25.0);
    _ratingView.hidden = NO;
    [self bindSelectedRestaurant];
}

-(void) bindSelectedRestaurant
{
    NSURL *logoImageURL = [NSURL URLWithString:[[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_logo"]];
    [self.imgLogo setImageWithURL:logoImageURL];
    self.imgLogo.layer.cornerRadius= self.imgLogo.frame.size.width / 2;
    self.imgLogo.layer.masksToBounds = YES;
    self.imgLogo.clipsToBounds = YES;
    self.lblRestName.text = [[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_name"];
    self.lblRestAddress.text = [[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_address"];
}

-(void) addRestaurantRating
{
    self.manager = [[RapidzzUserManager alloc] init];
    self.manager.delegate = self;
    NSDictionary *dictParams = @{@"rest_id":[[AppDelegate singleton].dictSelectedRestaurant objectForKey:@"rest_id"]
                                 ,@"login_id":[[AppDelegate singleton].userInfo objectForKey:@"login_id"]
                                 ,@"rating_value":[NSString stringWithFormat:@"%.02f",self.ratingView.rating]};
    
    
    [self.manager addRestaurantRating:dictParams];
}

-(void)DidAddRatingSuccessfully:(RapidzzBaseManager *)manager
{
    NSLog(@"Rating Added");
}


-(void)DidAddRatingFailed:(RapidzzBaseManager *)manager error:(RapidzzError *)error
{

}


-(void)didReceiveMemoryWarning
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
