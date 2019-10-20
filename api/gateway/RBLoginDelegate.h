//
//  RBLoginDelegate.h
//  raspberry
//
//  Created by trev on 8/13/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RBLoginDelegate

- (void)didLogin;
- (void)didNotLogin;

@end
