//
//  userSettingViewController.m
//  Yourder
//
//  Created by Arslan Ilyas on 01/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "userSettingViewController.h"
#import "SWRevealViewController.h"

@interface userSettingViewController ()
{
    NSArray *arrRadius;
}

@end

@implementation userSettingViewController

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
    

    arrRadius = [[NSArray alloc] initWithObjects:@"10",@"20",@"30",@"50", nil];
    self.txtSearchRadius.itemList = arrRadius;
    [self addToolBarToPickerView:self.txtSearchRadius];
    self.swNotifications = [[UISwitch alloc] init];
    self.swNotifications.transform = CGAffineTransformMakeScale(10, 10);
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



-(IBAction)saveChanges:(id)sender
{
    [[AppDelegate singleton] showAlertwith:nil andMessage:@"Successfully save changes"];
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
