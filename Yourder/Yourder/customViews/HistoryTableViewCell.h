//
//  HistoryTableViewCell.h
//  Yourder
//
//  Created by Arslan Ilyas on 11/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblRestName;
@property (weak, nonatomic) IBOutlet UILabel *lblRestAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgRestLogo;

@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@end
