//
//  ServiceRequestViewController.h
//  Yourder
//
//  Created by Ghafar Tanveer on 02/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceRequestTableViewCell.h"

@interface ServiceRequestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tblServiceRequest;
@property (weak,nonatomic) IBOutlet UIButton *btnDone;



@end
