//
//  DCUser.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCUser.h"
#import "RBNotificationEvent.h"

static NSOperationQueue* loadAvatarOperationQueue;

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

- (void)queueLoadAvatarImage {
    
    if(self.avatarImage != nil) return;
    
    self.avatarImage = [UIImage new];
    
    if(!self.avatarHash) return;
    
    if(!loadAvatarOperationQueue){
        loadAvatarOperationQueue = [[NSOperationQueue alloc] init];
        loadAvatarOperationQueue.maxConcurrentOperationCount = 1;
    }
    
    NSBlockOperation *loadAvatarOperation = [NSBlockOperation new];
    
    __weak __typeof__(NSBlockOperation) *weakOp = loadAvatarOperation;
    
    [loadAvatarOperation addExecutionBlock:^{
        
        if(weakOp.isCancelled) return;
        
        NSString *imgURLstr = [NSString stringWithFormat:@"https://cdn.discordapp.com/avatars/%@/%@.png", self.snowflake, self.avatarHash];
        NSURL* imgURL = [NSURL URLWithString:imgURLstr];
        
        NSData *data = [NSData dataWithContentsOfURL:imgURL];
        
        NSLog(@"loaded pfp for %@", self.username);
        
        self.avatarImage = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:RBNotificationEventFocusedChannelUpdated object:nil];
        });
    }];
    
    [loadAvatarOperationQueue addOperation:loadAvatarOperation];
}

@end
