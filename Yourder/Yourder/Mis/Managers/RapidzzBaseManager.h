//
//  BeplusedBaseManager.h
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RapidzzError.h"

@interface RapidzzBaseManager : NSObject

@property (strong, nonatomic) RapidzzError *error;
@property (strong, nonatomic) NSString *optionalMessage;
@property (strong, nonatomic) id data;
@property (readwrite) int counter;


- (void)handleResponse:(id)dictResponse;

@end
