//
//  BeplusedBaseManager.m
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "RapidzzBaseManager.h"

@implementation RapidzzBaseManager

/**
 ** A common method to handle the response.
 ** @dictResponse is the response dictionary that needs to be parsed.
 ** properties @error and @data are populated based on the response.
 **/

- (void)handleResponse:(id)dictResponse
{
    if ([dictResponse isKindOfClass:[NSString class]]) {
        self.data = dictResponse;
    }
    else if ([dictResponse isKindOfClass:[NSArray class]]) {
        self.data = dictResponse;
    }
    else
    {
        self.data = dictResponse;
        
//        NSDictionary *result = dictResponse;
//        self.error = nil;
//        self.optionalMessage = [result objectForKeyNotNull:@"messages"];
//        self.data = [dictResponse objectForKey:@"data"];
//        self.counter = [[dictResponse objectForKey:@"counter"] intValue];

    }
}

@end

