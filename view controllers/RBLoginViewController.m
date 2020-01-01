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

@property bool authenticated;

@end

@implementation RBLoginViewController

- (void)viewDidLoad{
	[super viewDidLoad];
    [RBClient.sharedInstance setLoginDelegate:self];
	self.navigationItem.hidesBackButton = YES;
    
    self.tokenTextField.text = UIPasteboard.generalPasteboard.string;
}

-(void)viewDidAppear:(BOOL)animated{
    self.authenticated = false;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (IBAction)loginButtonWasClicked {
	[[RBClient sharedInstance] connectWithTokenString:self.tokenTextField.text];
	[self.loginIndicator startAnimating];
	[self.loginIndicator setHidden:false];
    [self.loginButton setHidden:true];
    
    [self performSelector:@selector(checkAuth) withObject:nil afterDelay:5];
}

#pragma mark RBLoginDelegate

// called by RBWebSocketDelegate on successful auth
-(void)didLogin {
	[self performSegueWithIdentifier:@"login to guilds" sender:self];
    self.authenticated = true;
}

-(void)checkAuth {
    if(!self.authenticated){
        [self.loginIndicator stopAnimating];
        [self.loginIndicator setHidden:true];
        [self.loginButton setHidden:false];
        
        [RBClient.sharedInstance endSession];
    
        [[[UIAlertView alloc]initWithTitle:@"Not connecting!" message:@"Check that you have the correct token and a decent internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
