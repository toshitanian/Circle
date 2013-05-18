//
//  CMCrashReporter.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/18/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMCrashReporter.h"

@implementation CMCrashReporter

+(void)reportCrash:(NSString *)crash
{
    
   
    
    
    NSString *url=[[NSString alloc] initWithFormat:@"http://forceless.jp/circle/crash.php"];
    NSString *body = [NSString stringWithFormat:@"log=%@&id=%@",crash,[self getUUID]];
    NSString *postString = [NSString stringWithFormat:@"%@", body];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]  initWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
    request.HTTPMethod=@"POST";
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

#pragma mark - uuid
+(NSString *)getUUID
{
    NSString *uuid=[[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"];
    if(uuid){
        return  uuid;
    }else{
        uuid=[self stringWithUUID];
        [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return uuid;
    }
    
}


+ (NSString*) stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

# pragma mark - connection delegate

- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response {
    res_data = [NSMutableData data] ;
    [res_data setLength:0];
}


-(void) connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)receiveData {
    [res_data appendData:receiveData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Crash Report Success");
    NSLog(@"%@",[[NSString alloc] initWithData:res_data encoding:NSUTF8StringEncoding]);
  
}

- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error {
    NSLog(@"Failed:%@",error);
    
}

@end
