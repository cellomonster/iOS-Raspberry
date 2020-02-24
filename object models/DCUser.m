//
//  DCUser.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCUser.h"

@interface DCUser ()

@property bool isLoadingOrHasLoadedAvatarImage;

@end

@implementation DCUser
@synthesize snowflake = _snowflake;

- (DCUser*)initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if(![dict objectForKey:@"avatar"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize user from invalid dictionary!"
                              userInfo:dict];
	}
    
    self.snowflake = [dict objectForKey:@"id"];
    
    self.username = [dict objectForKey:@"username"];
    self.avatarHash = [dict objectForKey:@"avatar"];
    
    return self;
}

- (UIImage *)loadAvatarImage {
    NSString *imgURLstr = [NSString stringWithFormat:@"https://cdn.discordapp.com/avatars/%@/%@.png", self.snowflake, self.avatarHash];
    NSURL* imgURL = [NSURL URLWithString:imgURLstr];
    
    if(imgURL){
        NSData *data = [NSData dataWithContentsOfURL:imgURL];
            
        NSLog(@"loaded pfp for %@", self.username);
            
        self.avatarImage = [UIImage imageWithData:data];
    
        return self.avatarImage;
    }else{
        return [UIImage imageNamed:@"default"];
    }
}

@end
