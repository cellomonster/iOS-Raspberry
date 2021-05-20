//
//  RBContactViewController.m
//  raspberry
//
//  Created by julian on 5/20/21.
//  Copyright (c) 2021 Trevir. All rights reserved.
//

#import "RBContactViewController.h"

@interface RBContactViewController ()

@property DCUser* user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discriminatorLabel;

@end

@implementation RBContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setSelectedUser:(DCUser*)user{
    self.view = self.view;
    self.profileImageView.image = user.avatarImage;
    self.nameLabel.text = user.username;
    self.discriminatorLabel.text = user.discriminator;
    
    self.user = user;
}

@end
