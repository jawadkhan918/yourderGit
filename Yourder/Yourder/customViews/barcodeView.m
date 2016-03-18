//
//  barcodeView.m
//  Yourder
//
//  Created by Rapidzz on 05/01/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "barcodeView.h"

@implementation barcodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
