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
	
	return self;
}

@end
