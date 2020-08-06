//
//  DCUser.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"

@interface DCUser : NSObject <DCDiscordObject>

@property NSString *username;
@property NSString *discriminator;
@property NSURL *avatarHash;
@property UIImage *avatarImage;
@property bool isBot;

- (DCUser *)initFromDictionary:(NSDictionary *)dict;
- (void)queueLoadAvatarImage;

@end
