//
//  RBMessageItem.h
//  raspberry
//
//  Created by trevir on 11/4/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"
#import "DCUser.h"
#import "DCGuildMember.h"

@protocol RBMessageItem <DCDiscordObject>

@property DCUser *author;
@property NSDate *time;
@property DCGuildMember *member;

@end
