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
#import "RBMessageDelegate.h"

@interface RBChatViewController : UIViewController <UIBubbleTableViewDataSource, RBMessageDelegate>

@property DCChannel *activeChannel;

@end
