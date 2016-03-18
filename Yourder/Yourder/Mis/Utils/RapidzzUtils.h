//
//  BeplusedUtils.h
//  Beplused
//
//  Created by Arslan Ilyas on 03/10/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RapidzzUtilsDelegate <NSObject>

@optional

- (void)didPhotoUploaded:(NSString *)photoName andIncidenciaID:(NSString *)incidenciaID;
- (void)didImageFailedToUpload:(NSString *)error;

@end

@interface RapidzzUtils : NSObject <NSURLConnectionDelegate>

+ (BOOL) validateEmail: (NSString *) candidate;

+ (CGFloat) textHeightForString:(NSString *)string forFont:(UIFont *)font inWidth:(CGFloat)availableWidth;

- (void)sendFiles:(NSArray *)files withParms:(NSDictionary *)params withMethod:(NSString *)method;

- (void)sendFile1WithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params;
- (void)sendFile2WithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params;
- (void)sendFile3WithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params;

@property (nonatomic, strong) id<RapidzzUtilsDelegate> bDelegate;


- (void)sendVideoFileWithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params;

+ (CGSize) labelSizeForString:(NSString *)string forFont:(UIFont *)font inWidth:(CGFloat)availableWidth;

@property (nonatomic, strong) NSString *imgFileName;
@property (nonatomic, strong) NSString *incidenciaID;

@end
