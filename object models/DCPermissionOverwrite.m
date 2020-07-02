//
//  DCPermissionOverwrite.m
//  raspberry
//
//  Created by julian on 7/2/20.
//  Copyright (c) 2020 Trevir. All rights reserved.
//

#import "DCPermissionOverwrite.h"

@implementation DCPermissionOverwrite

-(DCPermissionOverwrite*)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if(![dict objectForKey:@"allow"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize permission overwrite from invalid dictionary!"
                              userInfo:dict];
	}
    
    self.appliesToSnowflake = [dict objectForKey:@"id"];
    
    NSString* type = [dict objectForKey:@"type"];
    if([type isEqualToString:@"member"]){
        self.type = DCPermissionOverwriteTypeMember;
    }else{
        self.type = DCPermissionOverwriteTypeRole;
    }
    
    self.allow = [[dict objectForKey:@"allow"] intValue];
    self.deny = [[dict objectForKey:@"deny"] intValue];
    
    return self;
}

@end
