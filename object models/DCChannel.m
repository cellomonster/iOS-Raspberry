//
//  DCChannel.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCChannel.h"

@implementation DCChannel

- (DCChannel *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
	
	if(![dict objectForKey:@"type"]){
		[NSException exceptionWithName:@"invalid dictionary"
														reason:@"tried to initialize channel from invalid dictionary!"
													userInfo:dict];
	}
	
	self.snowflake = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
	
	NSLog(@"| %@", self.name);
	
	return self;
}

@end
