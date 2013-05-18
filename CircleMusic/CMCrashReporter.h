//
//  CMCrashReporter.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/18/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://blog.dealforest.net/2012/03/ios-android-per-aes-crypt-connection/ Crypto

@interface CMCrashReporter : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData   *res_data;
}

+(void)reportCrash:(NSString *)crash;
@end
