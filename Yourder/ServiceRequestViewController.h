//
//  ServiceRequestViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 21/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceRequestViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@end
