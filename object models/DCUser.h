//
//  DCUser.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"

@interface DCUser : DCDiscordObject

@property NSString *username;
@property NSString *discriminator;
@property NSString *avatarHash;
@property bool isBot;

@end
