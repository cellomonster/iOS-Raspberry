//
//  RBCommon.m
//  raspberry
//
//  Created by Trevir on 4/20/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBCommon.h"

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
