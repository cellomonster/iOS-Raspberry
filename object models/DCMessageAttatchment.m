//
//  DCMessageAttatchment.m
//  Disco
//
//  Created by Trevir on 3/2/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCMessageAttatchment.h"
#import "FTWCache.h"
#import "RBNotificationEvent.h"

static NSOperationQueue* attachmentLoadOperationQueue;

@implementation DCMessageAttatchment
@synthesize snowflake = _snowflake;
@synthesize author = _author;
@synthesize timestamp = _timestamp;
@synthesize member = _member;

- (DCMessageAttatchment*)initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    
    self.snowflake = [dict objectForKey:@"id"];
    self.fileName = [dict objectForKey:@"filename"];
    
    self.fileURL = [NSURL URLWithString:[dict objectForKey:@"url"]];
    
    self.imageWidth = (NSUInteger)[dict objectForKey:@"width"];
    self.imageHeight = (NSUInteger)[dict objectForKey:@"height"];
    
#warning there's probably a much better way to do this
    if([[self.fileName pathExtension] isEqualToString:@"png"] || [[self.fileName pathExtension] isEqualToString:@"jpg"] || [[self.fileName pathExtension] isEqualToString:@"jpeg"] || [[self.fileName pathExtension] isEqualToString:@"gif"] || [[self.fileName pathExtension] isEqualToString:@"webp"])
        self.attachmentType = DCMessageAttatchmentTypeImage;
    else
        self.attachmentType = DCMessageAttatchmentTypeOther;
    
    if(!attachmentLoadOperationQueue){
        attachmentLoadOperationQueue = [[NSOperationQueue alloc] init];
        attachmentLoadOperationQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)queueLoadImageOperation {
    if(self.attachmentType == DCMessageAttatchmentTypeImage){
        NSBlockOperation *loadImageOperation = [NSBlockOperation new];
        
        self.image = [UIImage new];
        
        [loadImageOperation addExecutionBlock:^{
            
            NSLog(@"loading attachment image... %@", self.fileURL);
            
            NSData *data = [NSData dataWithContentsOfURL:self.fileURL];
            
            NSLog(@"loaded image %@", self.fileURL);
            
            self.image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RBNotificationEventFocusedChannelUpdated object:nil];
            });
        }];
        
        [attachmentLoadOperationQueue addOperation:loadImageOperation];
    }
}

@end
