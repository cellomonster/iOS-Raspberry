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
	
	NSLog(@"| %@", self.name);
	
	return self;
}

- (NSArray *)retrieveMessages:(int)numberOfMessages {
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:numberOfMessages];
	
	//Generate URL from args
	NSMutableString* getChannelAddress = [[NSString stringWithFormat: @"https://discordapp.com/api/channels/%@/messages?", self.snowflake] mutableCopy];
    
    [getChannelAddress appendString:[NSString stringWithFormat:@"limit=%i", numberOfMessages]];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getChannelAddress] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
	
	[urlRequest addValue:RBClient.sharedInstance.tokenString forHTTPHeaderField:@"Authorization"];
	[urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSError *error;
	NSHTTPURLResponse *responseCode;
	NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
    
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
    NSURL* channelURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://discordapp.com/api/channels/%@/messages", self.snowflake]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:channelURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];
    
    NSString* messageString = [NSString stringWithFormat:@"{\"content\":\"%@\"}", message];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setHTTPBody:[NSData dataWithBytes:[messageString UTF8String] length:[messageString length]]];
    [urlRequest addValue:RBClient.sharedInstance.tokenString forHTTPHeaderField:@"Authorization"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
    
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
