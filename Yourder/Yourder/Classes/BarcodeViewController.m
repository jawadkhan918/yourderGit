//
//  BarcodeViewController.m
//  Yourder
//
//  Created by Rapidzz on 22/12/2015.
//  Copyright © 2015 Rapidzz. All rights reserved.
//

#import "BarcodeViewController.h"

@interface BarcodeViewController()
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
}
@end

@implementation BarcodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getRestaurantTables];
    //[self callBarcode];
    
    
}

-(void) callBarcode
{
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input)
    {
        [_session addInput:_input];
    }
    else
    {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];

    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
}


-(void) getRestaurantTables
{
    // DUMMY DATA
    NSDictionary *dictRestaurant = @{@"restid":@"1",@"barcode":@"Res-01-001", @"tablenumber":@"1"};
    [self.arrTables addObject:dictRestaurant];
    
    NSDictionary *dictRestaurant1 = @{@"restid":@"2",@"barcode":@"Res-01-002", @"tablenumber":@"2"};
    [self.arrTables addObject:dictRestaurant1];
    
    NSDictionary *dictRestaurant2 = @{@"restid":@"3",@"barcode":@"Res-01-003", @"tablenumber":@"3"};
    [self.arrTables addObject:dictRestaurant2];
    
    NSDictionary *dictRestaurant3 = @{@"restid":@"4",@"barcode":@"Res-01-004", @"tablenumber":@"4"};
    [self.arrTables addObject:dictRestaurant3];
    
    NSDictionary *dictRestaurant4 = @{@"restid":@"5",@"barcode":@"Res-01-005", @"tablenumber":@"5"};
    [self.arrTables addObject:dictRestaurant4];
    
    NSDictionary *dictRestaurant5 = @{@"restid":@"6",@"barcode":@"Res-01-006", @"tablenumber":@"6"};
    [self.arrTables addObject:dictRestaurant5];
    
    NSDictionary *dictRestaurant6 = @{@"restid":@"7",@"barcode":@"Res-01-007", @"tablenumber":@"7"};
    [self.arrTables addObject:dictRestaurant6];
    
    NSDictionary *dictRestaurant7 = @{@"restid":@"8",@"barcode":@"Res-01-008", @"tablenumber":@"8"};
    [self.arrTables addObject:dictRestaurant7];
    
    NSDictionary *dictRestaurant8 = @{@"restid":@"9",@"barcode":@"Res-01-009", @"tablenumber":@"9"};
    [self.arrTables addObject:dictRestaurant8];
    
    NSDictionary *dictRestaurant9 = @{@"restid":@"10",@"barcode":@"Res-01-0010", @"tablenumber":@"10"};
    [self.arrTables addObject:dictRestaurant9];
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
            self.txtBarcode.text = detectionString;
            [_highlightView removeFromSuperview];
            [_prevLayer removeFromSuperlayer];
            [_label removeFromSuperview];
            break;
        }
        else
            _label.text = @"(none)";

    }
    
    _highlightView.frame = highlightViewRect;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)Scan:(id)sender
{
    //OPEN CAMERA FOR BARCODE
    [self callBarcode];
}


-(IBAction)go:(id)sender
{
    [self performSegueWithIdentifier:@"BarcodeToRestaurantmenu" sender:self];
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
