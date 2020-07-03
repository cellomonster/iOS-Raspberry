//
//  DCMessageAttatchment.m
//  Disco
//
//  Created by Trevir on 3/2/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCMessageAttatchment.h"
#import "FTWCache.h"

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
    
    return self;
}

- (void)queueLoadImageOperationInQueue:(NSOperationQueue *)queue withCompletionHandler:(void(^)())handler{
    if(self.attachmentType == DCMessageAttatchmentTypeImage){
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        
        [loadImageOperation addExecutionBlock:^{
            
            NSLog(@"loading attachment image... %@", self.fileURL);
            
            NSData *data = [NSData dataWithContentsOfURL:self.fileURL];
            
            NSLog(@"loaded image %@", self.fileURL);
            
            self.image = [UIImage imageWithData:data];
            
            _attachmentLoadCompletionHandler = [handler copy];
            
            _attachmentLoadCompletionHandler();
            
            _attachmentLoadCompletionHandler = nil;
        }];
        
        [queue addOperation:loadImageOperation];
    }
}

@end
