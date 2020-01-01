//
//  RBUserStore.h
//  raspberry
//
//  Created by trevir on 12/30/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUser.h"

@interface RBUserStore : NSObject

- (RBUserStore*)init;

-(void)addUser:(DCUser*)user;
-(void)removeUserBySnowflake:(NSString*)snowflake;

-(DCUser*)getUserBySnowflake:(NSString*)snowflake;

@end
