//
//  RBCommon.m
//  raspberry
//
//  Created by Trevir on 4/20/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBCommon.h"
#import "FTWCache.h"

@implementation RBCommon

+ (NSDictionary *)parseJSON:(id)message{
	
	if(![message isKindOfClass:[NSString class]]){
		// TODO: report error
		NSLog(@"!message wasn't a string!");
		return nil;
	}
	
	NSError *error = nil;
	NSData *data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
	id object = [NSJSONSerialization
							 JSONObjectWithData:data
							 options:0
							 error:&error];
	
	if(error) {
		// TODO: report error
		NSLog(@"!parsing error!");
		return nil;
	}
	
	if(![object isKindOfClass:[NSDictionary class]]) {
		// TODO: report error
		NSLog(@"!parsed json was not a dictionary!");
		return nil;
	}
	
	return (NSDictionary *)object;
}

@end

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5Hash {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
