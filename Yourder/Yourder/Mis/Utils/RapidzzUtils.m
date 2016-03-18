//
//  BeplusedUtils.m
//  Beplused
//
//  Created by Arslan Ilyas on 03/10/2013.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "RapidzzUtils.h"

@implementation RapidzzUtils

NSMutableData *responseData;

+ (CGSize) labelSizeForString:(NSString *)string forFont:(UIFont *)font inWidth:(CGFloat)availableWidth
{
    CGRect totalLabelFrame = [string boundingRectWithSize:CGSizeMake(availableWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: font} context:nil];
    
    //    NSLog(@"Frame Height: %f", totalLabelFrame.size.height);
    
    return totalLabelFrame.size;
}


+ (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


+ (CGFloat) textHeightForString:(NSString *)string forFont:(UIFont *)font inWidth:(CGFloat)availableWidth
{
    return [RapidzzUtils labelSizeForString:string forFont:font inWidth:availableWidth].width;
}

- (void)sendFiles:(NSArray *)files withParms:(NSDictionary *)params withMethod:(NSString *)method {
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://37.59.122.141/experiments/municipalidad/rest_api/rest_incidencias.php?action=send_pics"]];
    
    [request setHTTPMethod:method];
    //[request setTimeoutInterval:90];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (NSDictionary *dict in files ) {
    
        NSData *imgData = [dict objectForKey:@"photoData"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", [dict objectForKey:@"photoName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imgData]];
        
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

- (void)sendFile1WithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params
{
    
    self.imgFileName = filename;
    self.incidenciaID = [params objectForKey:[[params allKeys] firstObject]];
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://37.59.122.141/experiments/municipalidad/rest_api/rest_incidencias.php?action=send_pics"]];

    [request setHTTPMethod:method];
    //[request setTimeoutInterval:90];
    
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"pic0\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:dataFile]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)sendFile2WithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params
{
    
    self.imgFileName = filename;
    self.incidenciaID = [params objectForKey:[[params allKeys] firstObject]];
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://37.59.122.141/experiments/municipalidad/rest_api/rest_incidencias.php?action=send_pics"]];
    [request setHTTPMethod:method];
    //[request setTimeoutInterval:90];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"pic1\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:dataFile]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)sendFile3WithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params
{
    
    self.imgFileName = filename;
    self.incidenciaID = [params objectForKey:[[params allKeys] firstObject]];
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://37.59.122.141/experiments/municipalidad/rest_api/rest_incidencias.php?action=send_pics"]];
    [request setHTTPMethod:method];
    //[request setTimeoutInterval:90];
    
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"pic2\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:dataFile]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}




- (void)sendVideoFileWithData:(NSData *)dataFile Method:(NSString *)method URL:(NSString *)urlString JSON:(NSData *)jsonBody fileName:(NSString *)filename withParams:(NSDictionary *)params
{
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setURL:[NSURL URLWithString:@"http://mobile.beplused.com/api/?reqtype=post_photo&email=edwardschiff2@gmail.com&password=1234567*&caption=test"]];
    [request setHTTPMethod:method];
    //[request setTimeoutInterval:60];
    
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"video\"; filename=\"video\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:dataFile]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
   

    
	[request setHTTPBody:body];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.bDelegate)
    {
        [self.bDelegate didImageFailedToUpload:error.description];
    }
    //[self.delegate didPhotoUploadFailed:error.description errorCode:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DisplayedError"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ErrorCount"];
    
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    responseString = [[responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"] mutableCopy];
    
    if (self.bDelegate)
    {
        [self.bDelegate didPhotoUploaded:self.imgFileName andIncidenciaID:self.incidenciaID];
    }
    
    
}


@end
