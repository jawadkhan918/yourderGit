//
//  barcodeView.h
//  Yourder
//
//  Created by Rapidzz on 05/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface barcodeView : UIView <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtBarcode;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;




@end
