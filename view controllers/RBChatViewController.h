//
//  RBChatViewController.h
//  raspberry
//
//  Created by trevir on 10/18/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCChannel.h"
#import "UIBubbleTableView.h"

@interface RBChatViewController : UIViewController <UIBubbleTableViewDataSource>

-(void)subscribeToChannelEvents:(DCChannel*)channel loadNumberOfMessages:(int)numMessages;

@end
