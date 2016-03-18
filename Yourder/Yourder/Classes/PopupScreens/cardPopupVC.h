//
//  cardPopupVC.h
//  Yourder
//
//  Created by Ghafar Tanveer on 26/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface cardPopupVC : UIViewController<UITextFieldDelegate>


@property (weak,nonatomic) IBOutlet UIButton *btnCancel;
@property (weak,nonatomic) IBOutlet UIButton *btnDone;

@property (weak,nonatomic) IBOutlet UITextField *txtName;
@property (weak,nonatomic) IBOutlet UITextField *txtCardNo;
@property (weak,nonatomic) IBOutlet IQDropDownTextField *txtcardExpiry;
@property (weak,nonatomic) IBOutlet UITextField *txtCardCVV;


@end
