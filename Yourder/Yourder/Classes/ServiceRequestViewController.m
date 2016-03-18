//
//  ServiceRequestViewController.m
//  Yourder
//
//  Created by Ghafar Tanveer on 02/03/2016.
//  Copyright © 2016 Rapidzz. All rights reserved.
//

#import "ServiceRequestViewController.h"

@interface ServiceRequestViewController ()
{
    NSArray *arrServices;
    NSMutableArray *arrSelectServices;
}

@end

@implementation ServiceRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     arrServices = [[NSArray alloc]initWithObjects:@"Plate",@"Spoon",@"Fork",@"Knife",@"Napkin",@"Chopsticks",@"Clean up", nil];
    arrSelectServices = [[NSMutableArray alloc]init];
    self.tblServiceRequest.delegate = self;
    self.tblServiceRequest.layer.cornerRadius = 8.0;
    self.tblServiceRequest.clipsToBounds = YES;
    self.btnDone.layer.cornerRadius = 8.0;
    self.btnDone.clipsToBounds = YES;
    
}



# pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    ServiceRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      cell.accessoryType = UITableViewCellAccessoryNone;
    if (cell == nil)
    {
        cell = [[ServiceRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:MyIdentifier];
    }

    for(int i=0;i<arrSelectServices.count;i++)
    {
        NSString *strService = [arrServices objectAtIndex:indexPath.row];
        NSString *strSelectService = [arrSelectServices objectAtIndex:i];
        
        if([strSelectService isEqualToString:strService])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    
    cell.lblServices.text = [arrServices objectAtIndex:indexPath.row];
        
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
   
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [arrSelectServices addObject:[arrServices objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [arrSelectServices removeObject:[arrServices objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
   
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
