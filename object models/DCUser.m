//
//  DCUser.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCUser.h"
#import "RBNotificationEvent.h"

static NSOperationQueue* avatarLoadOperationQueue;

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
    
    if(!avatarLoadOperationQueue){
        avatarLoadOperationQueue = [[NSOperationQueue alloc] init];
        avatarLoadOperationQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)queueLoadAvatarImage {
    
    if(self.avatarImage != nil) return;
    
    self.avatarImage = [UIImage new];
    
    if(!self.avatarHash) nil;
    
    NSBlockOperation *loadAvatarOperation = [NSBlockOperation new];
    
    NSString *imgURLstr = [NSString stringWithFormat:@"https://cdn.discordapp.com/avatars/%@/%@.png", self.snowflake, self.avatarHash];
    NSURL* imgURL = [NSURL URLWithString:imgURLstr];
    
    __weak __typeof__(NSBlockOperation) *weakOp = loadAvatarOperation;
    
    [loadAvatarOperation addExecutionBlock:^{
        
        NSData *data = [NSData dataWithContentsOfURL:imgURL];
        
        NSLog(@"loaded pfp for %@", self.username);
        
        self.avatarImage = [UIImage imageWithData:data];
        
        if(weakOp.isCancelled) return;
        
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [[NSNotificationCenter defaultCenter] postNotificationName:RBNotificationEventFocusedChannelUpdated object:nil];
        //            });
    }];
    
    [avatarLoadOperationQueue addOperation:loadAvatarOperation];
}

@end
