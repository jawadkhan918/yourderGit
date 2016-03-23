//
//  ServiceRequestViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 21/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "ServiceRequestViewController.h"

@interface ServiceRequestViewController ()
{
    NSArray *arrServices;
}

@end

@implementation ServiceRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrServices = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
}




# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:MyIdentifier];
    }
    
       cell.textLabel.text = [arrServices objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    /// Condition applied for data crime
    
    //    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame)
    //    {
    
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
