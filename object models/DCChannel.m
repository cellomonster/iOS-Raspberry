//
//  DCChannel.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCChannel.h"
#import "RBClient.h"
#import "DCMessage.h"
#import "DCMessageAttatchment.h"

@implementation DCChannel
@synthesize snowflake = _snowflake;

- (DCChannel *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
	
	self.snowflake = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
    id sortingPositionId = [dict objectForKey:@"position"];
    if(sortingPositionId != nil){
        self.sortingPosition = [sortingPositionId intValue];
    }
    
    self.parentCatagorySnowflake = [dict objectForKey:@"parent_id"];
    if(self.parentCatagorySnowflake == nil){
        self.parentCatagorySnowflake = @"no cat";
    }
    
    self.channelType = [[dict objectForKey:@"type"] intValue];
	
	NSLog(@"| %@ - %@ - %d", self.name, self.parentCatagorySnowflake ,self.sortingPosition);
	
	return self;
}

- (NSMutableURLRequest*)authedMutableURLRequestFromString:(NSString*)requestString{
    
    NSString* baseString = @"https://discordapp.com/api/channels/%@%@";
    NSString* compositeString = [NSString stringWithFormat:baseString, self.snowflake, requestString];
    NSURL* url = [NSURL URLWithString:compositeString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];

    [urlRequest addValue:RBClient.sharedInstance.tokenString forHTTPHeaderField:@"Authorization"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return urlRequest;
    
}

- (NSArray *)retrieveMessages:(int)numberOfMessages {
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:numberOfMessages];
    
    NSString* requestString = [NSString stringWithFormat:@"/messages?limit=%i", numberOfMessages];
	
	NSMutableURLRequest* request = [self authedMutableURLRequestFromString:requestString];
	
	NSError *error;
	NSHTTPURLResponse *responseCode;
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return nil;
    }
	
	if(response){
		NSArray* parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        for(id jsonMessage in parsedResponse){
            if([jsonMessage isKindOfClass:[NSDictionary class]]){
                DCMessage *message = [[DCMessage alloc] initFromDictionary:jsonMessage];
                [messages addObject:message];
                
                for(DCMessageAttatchment *messageAttachment in [message.attachments allValues]){
                    [messages addObject:messageAttachment];
                }
            }
        }
	}
	
	return [[messages reverseObjectEnumerator] allObjects];;
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

@end
