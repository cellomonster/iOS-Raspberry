//
//  RBContactViewController.h
//  raspberry
//
//  Created by julian on 5/20/21.
//  Copyright (c) 2021 Trevir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCUser.h"

@interface RBContactViewController : UITableViewController

-(void)setSelectedUser:(DCUser*)user;

@end
