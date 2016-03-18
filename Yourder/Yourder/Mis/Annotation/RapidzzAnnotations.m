//
//  BeplusedAnnotations.m
//  Beplused
//
//  Created by Arslan Ilyas on 21/10/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "RapidzzAnnotations.h"

@implementation RapidzzAnnotations

+ (RapidzzAnnotations *)annotationForCheckeIn:(NSDictionary *)checkin
{
    RapidzzAnnotations *annotation = [[RapidzzAnnotations alloc] init];
    annotation.checkin = checkin;
    return annotation;
}

- (NSString *)title
{
    return [self.checkin objectForKey:@"name"];
}

- (NSString *)subtitle
{
    return [self.checkin objectForKey:@"address"];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.checkin objectForKey:@"lat"] floatValue];
    coordinate.longitude = [[self.checkin objectForKey:@"long"] floatValue];
    
    return coordinate;
}


@end
