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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

@end

@implementation RBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (IBAction)loginButtonWasClicked {
	[[RBClient sharedInstance] setLoginDelegate:self];
	[[RBClient sharedInstance] connectWithTokenString:self.tokenTextField.text];
	[self.loginIndicator startAnimating];
	[self.loginIndicator setHidden:false];
}

#pragma mark RBLoginDelegate

// called by RBWebSocketDelegate on successful auth
-(void)didLogin {
	[self performSegueWithIdentifier:@"login to guilds" sender:self];
}

@end
