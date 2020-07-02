//
//  DCRole.m
//  Disco
//
//  Created by Trevir on 3/2/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCRole.h"

@implementation DCRole
@synthesize snowflake = _snowflake;

- (DCRole *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
    
    if(![dict objectForKey:@"hoist"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize role from invalid dictionary!"
                              userInfo:dict];
	}
    
    self.name = [dict objectForKey:@"name"];
    self.snowflake = [dict objectForKey:@"id"];
    self.permissions = [[dict objectForKey:@"permissions"] intValue];
	
	return self;
}

@end
