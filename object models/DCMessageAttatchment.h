//
//  DCMessageAttatchment.h
//  Disco
//
//  Created by Trevir on 3/2/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"
#import "RBMessageItem.h"

@interface DCMessageAttatchment : NSObject <RBMessageItem>

typedef NS_ENUM(NSInteger, DCMessageAttatchmentType) {
	DCMessageAttatchmentTypeImage,
	DCMessageAttatchmentTypeOther,
};

@property DCMessageAttatchmentType attachmentType;

@property NSString *fileName;
@property int sizeInBytes;
@property NSURL *fileURL;
@property NSURL *proxiedFileURLString;

@property NSUInteger imageWidth;
@property NSUInteger imageHeight;
@property UIImage *image;

@property bool writtenByUser;

- (DCMessageAttatchment*)initFromDictionary:(NSDictionary *)dict;
- (void)queueLoadImageOperation;

@end
