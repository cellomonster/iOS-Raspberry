//
//  DCPermissionOverwrite.h
//  raspberry
//
//  Created by julian on 7/2/20.
//  Copyright (c) 2020 Trevir. All rights reserved.
//

typedef NS_ENUM(NSInteger, DCPermissionOverwriteType) {
	DCPermissionOverwriteTypeRole,
    DCPermissionOverwriteTypeMember
};

@interface DCPermissionOverwrite : NSObject

@property NSString* appliesToSnowflake;
@property DCPermissionOverwriteType type;
@property int allow;
@property int deny;

-(DCPermissionOverwrite*)initWithDictionary:(NSDictionary*)dict;

@end
