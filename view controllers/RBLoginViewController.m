//
//  RBLoginViewController.m
//  raspberry
//
//  Created by Trevir on 8/6/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBLoginViewController.h"
#import "RBGuildStore.h"
#import "RBClient.h"

@interface RBLoginViewController ()

@property RBGuildStore* guildStore;
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

@end

@implementation RBLoginViewController

- (void)viewDidLoad{
	[super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
    
    [[RBClient sharedInstance] setLoginDelegate:self];
    
    self.tokenTextField.text = UIPasteboard.generalPasteboard.string;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (IBAction)loginButtonWasClicked {
	[[RBClient sharedInstance] connectWithTokenString:self.tokenTextField.text];
	[self.loginIndicator startAnimating];
	[self.loginIndicator setHidden:false];
    [self.loginButton setHidden:true];
}

#pragma mark RBLoginDelegate

// called by RBWebSocketDelegate on successful auth
-(void)didLogin {
	[self performSegueWithIdentifier:@"login to guilds" sender:self];
}

-(void)didNotLogin {
    [self.loginIndicator stopAnimating];
	[self.loginIndicator setHidden:true];
    [self.loginButton setHidden:false];
    
    [[[UIAlertView alloc]initWithTitle:@"Not connecting!" message:@"Check that you have the correct token and a decent internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
