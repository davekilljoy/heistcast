//
//  LoginModalViewController.m
//  HeistCast
//
//  Created by David Stubbs on 1/15/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import "LoginModalViewController.h"
#import <ShowKit/ShowKit.h>

@interface LoginModalViewController ()
{
}
@end

@implementation LoginModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Make sure the status bar is set back to white
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	
	//Button stuff
	UIImage *btnImage = [UIImage imageNamed:@"buttonBorder.png"];
	UIImage *newImg = [btnImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	UIImage *btnPressedImage = [UIImage imageNamed:@"buttonBody.png"];
	UIImage *newPressedImg = [btnPressedImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	[_presenterButton setBackgroundImage:newImg forState:UIControlStateNormal];
	[_presenterButton setBackgroundImage:newPressedImg forState:UIControlStateHighlighted];
	
	_presenterButton.titleLabel.font = [UIFont fontWithName:@"FreightSansMedium" size:16];
	
	[_viewerButton setBackgroundImage:newImg forState:UIControlStateNormal];
	[_viewerButton setBackgroundImage:newPressedImg forState:UIControlStateHighlighted];
	
	_viewerButton.titleLabel.font = [UIFont fontWithName:@"FreightSansMedium" size:16];
	
	[self _setActivityIndicator:YES];
	
}

-(void)doPresenterButton{

	[self _setActivityIndicator:NO];
	
	NSString *username = @"623.presenter";
	NSString *password = @"123456";
	
	NSLog(@"%@",username);
	
	[ShowKit login:username password:password withCompletionBlock:^(NSString* const connectionStatus) {
	if ([connectionStatus isEqualToString:SHKConnectionStatusLoggedIn]) {
		// Do stuff after successful login.
		
		[self performSegueWithIdentifier:@"loginPresenter" sender:self];
		
		NSLog(@"%@",@"Login Success");
	} else {
		// The login failed.
		NSLog(@"%@",@"Booo");
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Username or Password wrong. Please try again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		
		[self _setActivityIndicator:YES];
	}
	}];

}

-(void)doViewerButton{

	[self _setActivityIndicator:NO];
	
	NSString *username = @"623.viewer";
	NSString *password = @"123456";
	
	NSLog(@"%@",username);
	
	[ShowKit login:username password:password withCompletionBlock:^(NSString* const connectionStatus) {
	if ([connectionStatus isEqualToString:SHKConnectionStatusLoggedIn]) {
		// Do stuff after successful login.
		
		[self performSegueWithIdentifier:@"loginViewer" sender:self];
		
		NSLog(@"%@",@"Login Success");
	} else {
		// The login failed.
		NSLog(@"%@",@"Booo");
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Username or Password wrong. Please try again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		
		[self _setActivityIndicator:YES];
	}
	}];

}

-(void)_setActivityIndicator: (BOOL)hidden
{
	if (hidden == YES){
	
		[self.activityIndicator stopAnimating];
		
	}else if (hidden == NO){
	
		[self.activityIndicator startAnimating];
		
	}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
