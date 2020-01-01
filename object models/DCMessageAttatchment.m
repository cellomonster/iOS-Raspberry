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
@synthesize time = _time;
@synthesize member = _member;


- (DCMessageAttatchment*)initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    
    self.snowflake = [dict objectForKey:@"id"];
    self.fileName = [dict objectForKey:@"filename"];
    
    self.fileURL = [NSURL URLWithString:[dict objectForKey:@"url"]];
    
    self.imageWidth = (NSUInteger)[dict objectForKey:@"width"];
    self.imageHeight = (NSUInteger)[dict objectForKey:@"height"];
    
    if(self.imageWidth)
        self.attachmentType = DCMessageAttatchmentTypeImage;
    else
        self.attachmentType = DCMessageAttatchmentTypeOther;
    
    return self;
}

- (UIImage *)loadImage {
    if(self.attachmentType == DCMessageAttatchmentTypeImage){
        NSData *data = [NSData dataWithContentsOfURL:self.fileURL];
        
        NSLog(@"loaded image %@", self.fileURL);
    
        self.image = [UIImage imageWithData:data];
        
        return self.image;
    }
    
    return nil;
}

@end
