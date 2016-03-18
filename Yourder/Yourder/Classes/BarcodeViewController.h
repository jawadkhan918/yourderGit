//
//  BarcodeViewController.h
//  Yourder
//
//  Created by Rapidzz on 22/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface BarcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) NSMutableArray *arrTables;
@property (weak, nonatomic) IBOutlet UITextField *txtBarcode;


@end
