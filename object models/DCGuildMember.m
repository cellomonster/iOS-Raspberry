//
//  DCGuildMember.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCGuildMember.h"
#import "RBClient.h"
#import "DCUser.h"
#import "DCGuild.h"
#import "DCRole.h"
#import "RBUserStore.h"

@implementation DCGuildMember

- (DCGuildMember*)initFromDictionary:(NSDictionary *)dict inGuild:(DCGuild*)guild{
    self = [super init];
    
    self.nickname = [dict objectForKey:@"nick"];
    
    NSDictionary* jsonUser = [dict objectForKey:@"user"];
    self.user = [RBClient.sharedInstance.userStore getUserBySnowflake:[jsonUser objectForKey:@"id"]];
    if(self.user == RBClient.sharedInstance.userStore.clientUser){
        guild.userGuildMember = self;
    }else if(self.user == nil){
        self.user = [[DCUser alloc] initFromDictionary:jsonUser];
        [RBClient.sharedInstance.userStore addUser:self.user];
    }
    
    NSArray* roleIds = (NSArray*)[dict objectForKey:@"roles"];
    self.roles = [[NSMutableDictionary alloc] initWithCapacity:roleIds.count];
    for(NSString* roleId in roleIds){
        DCRole* role = [guild.roles objectForKey:roleId];
        if(role != nil){
            [self.roles setObject:role forKey:role.snowflake];
        }
    }
    
    return self;
}

@end
