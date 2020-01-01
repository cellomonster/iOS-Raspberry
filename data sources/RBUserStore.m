//
//  RBUserStore.m
//  raspberry
//
//  Created by trevir on 12/30/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBUserStore.h"

@interface RBUserStore ()

@property NSMutableDictionary* userDictionary;

@end

@implementation RBUserStore

-(RBUserStore*)init{
    
    self = [super init];
    
    self.userDictionary = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void)addUser:(DCUser*)user{
    [self.userDictionary setObject:user forKey:user.snowflake];
}

-(void)removeUserBySnowflake:(NSString*)snowflake{
    [self.userDictionary removeObjectForKey:snowflake];
}

-(DCUser*)getUserBySnowflake:(NSString*)snowflake{
    return [self.userDictionary objectForKey:snowflake];
}

@end
