//
//  CURLConnection.h
//  FinTech
//
//  Created by Bálint Róbert on 30/07/15.
//  Copyright (c) 2015 IncepTech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/// converts CURLCode into NSString taken from curl.h
NSString  * _Nonnull CURLCodeToNSString(NSUInteger code);

@interface CURLConnection : NSObject

+ (NSData * _Nullable)sendSynchronousRequest:(NSURLRequest * _Nonnull)request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError * _Nullable * _Nullable)error;

@end
