//
//  DCRole.h
//  Disco
//
//  Created by Trevir on 3/2/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"

@interface DCRole : NSObject <DCDiscordObject>

@property NSString *name;
@property UIColor *color;

@property int hiearchyLocation;
@property int permissions;
@property bool shownIndependentlyInUserList;
@property bool mentionable;

-(DCRole*)initFromDictionary:(NSDictionary*)dict;

@end
