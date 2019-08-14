//
//  DCGuild.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"

@interface DCGuild : DCDiscordObject

@property int sortingPosition;
@property NSArray *permissions;
@property bool ownedByUser;

@property NSString *name;
@property NSString *iconHash;

@property NSMutableDictionary *roles;
@property NSMutableDictionary *emoji;
@property NSMutableDictionary *members;
@property NSMutableDictionary *channels;

@property bool isLarge;
@property bool isAvailable;
@property bool sendNotificationForEveryMessage;

-(DCGuild*)initFromDictionary:(NSDictionary*)dict;

@end
