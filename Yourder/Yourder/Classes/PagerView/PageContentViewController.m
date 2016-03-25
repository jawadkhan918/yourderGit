//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.imageFile]];
    self.lblTitle.text  = self.titleText;
    self.lblSubTitle.text  = self.subTitleText;
    
    self.lblSubTitle.numberOfLines = 5;
    CGSize labelSize = [self.lblSubTitle.text sizeWithAttributes:@{NSFontAttributeName:self.lblSubTitle.font}];
    
      self.lblSubTitle.frame = CGRectMake(
                             self.lblSubTitle.frame.origin.x, self.lblSubTitle.frame.origin.y,
                             self.lblSubTitle.frame.size.width, labelSize.height*50);
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
