//
//  DCUser.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCUser.h"

@implementation DCUser

- (DCUser*)initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if(![dict objectForKey:@"avatar"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize user from invalid dictionary!"
                              userInfo:dict];
	}
    
    self.username = [dict objectForKey:@"username"];
    self.avatarHash = [dict objectForKey:@"avatar"];
    
    
    return self;
}

@end
