//
//  DCChannel.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCChannel.h"
#import "DCGuild.h"
#import "RBClient.h"
#import "DCGuildMember.h"
#import "DCUser.h"
#import "DCMessage.h"
#import "DCMessageAttatchment.h"
#import "DCPermissionOverwrite.h"
#import "RBNotificationEvent.h"

@interface DCChannel()

@property NSOperationQueue* imageLoadQueue;

@end

@implementation DCChannel
@synthesize snowflake = _snowflake;

- (DCChannel *)initFromDictionary:(NSDictionary *)dict andGuild:(DCGuild*)guild {
	self = [super init];
    
    if(![dict objectForKey:@"type"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize channel from invalid dictionary!"
                              userInfo:dict];
	}
    
    self.parentGuild = guild;
	
	self.snowflake = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
    self.channelType = [[dict objectForKey:@"type"] intValue];
    self.lastMessageReadOnLoginSnowflake = [dict objectForKey:@"last_message_id"];
    
    id sortingPositionId = [dict objectForKey:@"position"];
    if(sortingPositionId != nil){
        self.sortingPosition = [sortingPositionId intValue];
    }
    
    self.parentCatagorySnowflake = [dict objectForKey:@"parent_id"];
    if(self.parentCatagorySnowflake == nil){
        self.parentCatagorySnowflake = @"no cat";
    }
    
    NSArray* jsonPermissionOverwrites = (NSArray*)[dict objectForKey:@"permission_overwrites"];
    self.permissionOverwrites = [[NSMutableDictionary alloc] initWithCapacity:jsonPermissionOverwrites.count];
    for(NSDictionary* jsonPermissionOverwrite in jsonPermissionOverwrites){
        DCPermissionOverwrite* permOverwrite = [[DCPermissionOverwrite alloc] initWithDictionary:jsonPermissionOverwrite];
        if(permOverwrite.appliesToSnowflake != nil)
            [self.permissionOverwrites setObject:permOverwrite forKey:permOverwrite.appliesToSnowflake];
    }
    
    int isVisibleCode = 0;
    
    for(DCPermissionOverwrite* permOverwrite in [self.permissionOverwrites allValues]){
        
        if(permOverwrite.type == DCPermissionOverwriteTypeRole){
            
            //Check if this channel dictates permissions over any roles the user has
            if([guild.userGuildMember.roles objectForKey:permOverwrite.appliesToSnowflake]){
                
                if((permOverwrite.deny & 1024) == 1024 && isVisibleCode < 1)
                    isVisibleCode = 1;
                
                if(((permOverwrite.allow & 1024) == 1024) && isVisibleCode < 2)
                    isVisibleCode = 2;
            }
        }else{
            //Check if
            if([permOverwrite.appliesToSnowflake isEqualToString:guild.userGuildMember.user.snowflake]){
                
                if((permOverwrite.deny & 1024) == 1024 && isVisibleCode < 3)
                    isVisibleCode = 3;
                
                if((permOverwrite.allow & 1024) == 1024){
                    isVisibleCode = 4;
                    break;
                }
            }
        }
    }
    
    self.isVisible = (isVisibleCode == 0 || isVisibleCode == 2 || isVisibleCode == 4);
	
	return self;
}

- (NSMutableURLRequest*)authedMutableURLRequestFromString:(NSString*)requestString{
    
    NSString* baseString = @"https://discordapp.com/api/channels/%@%@";
    NSString* compositeString = [NSString stringWithFormat:baseString, self.snowflake, requestString];
    NSURL* url = [NSURL URLWithString:compositeString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    
    [urlRequest addValue:RBClient.sharedInstance.tokenString forHTTPHeaderField:@"Authorization"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return urlRequest;
}

- (void)retrieveMessages:(int)numberOfMessages {
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:numberOfMessages];
    
    NSString* requestString = [NSString stringWithFormat:@"/messages?limit=%i", numberOfMessages];
	
	NSMutableURLRequest* request = [self authedMutableURLRequestFromString:requestString];
	
	NSError *error;
	NSHTTPURLResponse *responseCode;
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
	
	if(response){
		NSArray* parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        for(id jsonMessage in parsedResponse){
            if([jsonMessage isKindOfClass:[NSDictionary class]]){
                DCMessage *message = [[DCMessage alloc] initFromDictionary:jsonMessage];
                
                for(DCMessageAttatchment *messageAttachment in [message.attachments allValues]){
                    [messages addObject:messageAttachment];
                }
                
                [messages addObject:message];
            }
        }
	}
	
	self.messages = (NSMutableArray*)[[messages reverseObjectEnumerator] allObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RBNotificationEventFocusedChannelUpdated object:nil];
}

- (void)releaseMessages{
    self.messages = nil;
}

- (void)sendMessage:(NSString*)message {
    NSMutableURLRequest* request = [self authedMutableURLRequestFromString:@"/messages"];
    
    NSString* messageString = [NSString stringWithFormat:@"{\"content\":\"%@\"}", message];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[messageString UTF8String] length:[messageString length]]];
    
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)markAsReadWithMessage:(DCMessage*)message{
    self.isRead = true;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString* requestString = [NSString stringWithFormat:@"/messages/%@/ack", message.snowflake];
        
        NSMutableURLRequest* request = [self authedMutableURLRequestFromString:requestString];
        
        [request setHTTPMethod:@"POST"];
        
        NSString* messageString = @"{\"token\":\"a\"}";
        [request setHTTPBody:[NSData dataWithBytes:[messageString UTF8String] length:[messageString length]]];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
    });
}


- (void)handleNewMessage:(DCMessage*)message{
    if(self.isCurrentlyFocused){
        [self.messages addObject:message];
        
        for(DCMessageAttatchment *messageAttachment in [message.attachments allValues]){
            [self.messages addObject:messageAttachment];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RBNotificationEventFocusedChannelUpdated object:nil];
    }else{
        self.isRead = false;
    }
}

@end
