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

@implementation DCChannel

- (DCChannel *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
	
	if(![dict objectForKey:@"type"]){
		[NSException exceptionWithName:@"invalid dictionary"
														reason:@"tried to initialize channel from invalid dictionary!"
													userInfo:dict];
	}
	
	self.snowflake = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
	
	NSLog(@"| %@", self.name);
	
	return self;
}

- (NSArray *)getLastNumMessages:(int)number {
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:number];
	
	//Generate URL from args
	NSMutableString* getChannelAddress = [[NSString stringWithFormat: @"https://discordapp.com/api/channels/%@/messages?", self.snowflake] mutableCopy];
    
    [getChannelAddress appendString:[NSString stringWithFormat:@"limit=%i", number]];
	
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
            }
        }
	}
	
	return [[messages reverseObjectEnumerator] allObjects];;
}

@end
