//
//  BeplusedAnnotations.h
//  Beplused
//
//  Created by Arslan Ilyas on 21/10/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RapidzzAnnotations : NSObject <MKAnnotation>

+ (RapidzzAnnotations *)annotationForCheckeIn:(NSDictionary *)checkin;

@property (nonatomic, strong) NSDictionary *checkin;


@end
