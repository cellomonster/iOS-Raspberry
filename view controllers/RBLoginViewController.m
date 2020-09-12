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
#import "RBWebSocket.h"
#import "RBWebSocketDelegate.h"
#import "RBNotificationEvent.h"

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
    
	self.navigationItem.hidesBackButton = YES;
    
    NSString *lastUsableToken = [NSUserDefaults.standardUserDefaults objectForKey:@"last usable token"];
    
    if(lastUsableToken){
        self.tokenTextField.text = lastUsableToken;
    }else{
        self.tokenTextField.text = UIPasteboard.generalPasteboard.string;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin)
                                                 name:RBNotificationEventDidLogin
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    self.authenticated = false;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (IBAction)loginButtonWasClicked {
	[RBClient.sharedInstance newSessionWithTokenString:self.tokenTextField.text shouldResume:false];
	[self.loginIndicator startAnimating];
	[self.loginIndicator setHidden:false];
    [self.loginButton setHidden:true];
    
    [self performSelector:@selector(checkAuth) withObject:nil afterDelay:10];
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
