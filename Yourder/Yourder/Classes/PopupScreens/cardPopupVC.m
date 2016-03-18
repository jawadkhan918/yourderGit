//
//  cardPopupVC.m
//  Yourder
//
//  Created by Ghafar Tanveer on 26/02/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "cardPopupVC.h"
#import "IQDropDownTextField.h"

@interface cardPopupVC ()
{
    BOOL datePicker;
}

@end

@implementation cardPopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtCardNo.keyboardType = UIKeyboardTypeNumberPad;
    self.txtCardCVV.keyboardType = UIKeyboardTypeNumberPad;
    
    [self creatNumericKeyboard];
}


// CREAT NUMERIC KEYBOARD FOR NUMERIC INPUT

-(void)creatNumericKeyboard
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.txtCardCVV.inputAccessoryView = numberToolbar;
    self.txtCardNo.inputAccessoryView = numberToolbar;
    
    
}

-(void)doneWithNumberPad{
    [self.txtCardNo resignFirstResponder];
    [self.txtCardCVV resignFirstResponder];
    //numberTextField.text = @"";
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(datePicker == NO)
        if(textField.tag == 100)
        {
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"MM-yyyy"];
            self.txtcardExpiry.text = [_formatter stringFromDate:[NSDate date]];
            [self.txtcardExpiry setDateFormatter:_formatter];
            
            [self.txtcardExpiry setDropDownMode:IQDropDownModeDatePicker];
            
            [self addToolBarToPickerView:self.txtcardExpiry];
            datePicker = YES;
        }
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
