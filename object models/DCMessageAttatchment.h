//
//  DCMessageAttatchment.h
//  Disco
//
//  Created by Trevir on 3/2/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCMessageAttatchment : NSObject

@property NSString *fileName;
@property int sizeInBytes;
@property NSURL *fileURLString;
@property NSURL *proxiedFileURLString;

@property int imageWidth;
@property int imageHeight;

@end
