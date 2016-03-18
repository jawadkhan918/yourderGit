//
//  BeplusedError.h
//  Beplused
//
//  Created by Arslan Ilyas on 27/09/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RapidzzError : NSObject

@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *message;

- (id)initWithDictionary:(NSDictionary*)dictResult;
- (id)initWithError:(NSError*)error;
- (id)initWithMessage:(NSString*)message errorCode:(NSString*)code;

@end
