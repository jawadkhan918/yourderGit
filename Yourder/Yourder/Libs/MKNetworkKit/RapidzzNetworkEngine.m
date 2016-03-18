//
//  BeplusedNetworkEngine.m
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "RapidzzNetworkEngine.h"

@implementation RapidzzNetworkEngine

+ (id)sharedInstance
{
    static RapidzzNetworkEngine *sharedInstance;
    static dispatch_once_t done;
    
    dispatch_once(&done, ^{
        sharedInstance = [[RapidzzNetworkEngine alloc] initWithHostName:k_MAIN_URL];
        [sharedInstance useCache];
    });
    
    return sharedInstance;
}


@end
