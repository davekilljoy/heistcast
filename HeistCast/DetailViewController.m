//
//  DetailViewController.m
//  JSONTableView
//
//  Created by David Stubbs on 1/15/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//	I love Jenny

#import "DetailViewController.h"
#import <ShowKit/ShowKit.h>

@interface DetailViewController ()
{
  UIWebView *_webView;
}

- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

	if (self.detailItem) {
	
		NSString *detailWebURL = [_detailItem objectForKey:@"body"];
		
		NSURL *url = [NSURL URLWithString:detailWebURL];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		
		[_webView loadRequest:request];
	}
	
	//self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	
	self.navigationItem.backBarButtonItem = backButton;
	
	//Set new title with the title from the JSON
	NSString *detailTitle = [_detailItem objectForKey:@"title"];
	NSString *Title = [detailTitle uppercaseString];
	
	self.title = Title;
	
	//Setting up hangup button image background
	UIImage *endBtnImage = [UIImage imageNamed:@"buttonOverlay.png"];
	UIImage *newEndImg = [endBtnImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];

	[_hangUp setBackgroundImage:newEndImg forState:UIControlStateNormal];
	
	//Standard Button Style
	UIImage *btnImage = [UIImage imageNamed:@"buttonBorder.png"];
	UIImage *newImg = [btnImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	UIImage *btnPressedImage = [UIImage imageNamed:@"buttonBody.png"];
	UIImage *newPressedImg = [btnPressedImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	[_hangupBeforeCall setBackgroundImage:newImg forState:UIControlStateNormal];
	[_hangupBeforeCall setBackgroundImage:newPressedImg forState:UIControlStateHighlighted];
	
	_hangupBeforeCall.titleLabel.font = [UIFont fontWithName:@"FreightSansMedium" size:16.f];
	
	//Hide status overlay
	_callStatus.hidden=YES;
	_callStatus.alpha=0.0;
	_callStatusLabel.font = [UIFont fontWithName:@"FreightSansBook" size:30];
	
	//Hangup button load stuff, hide and set font
	_hangUp.hidden=YES;
	_hangUp.titleLabel.font = [UIFont fontWithName:@"FreightSansMedium" size:16];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(connectionStateChanged:)
     name:SHKConnectionStatusChangedNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(remoteClientStatusChanged:)
     name:SHKRemoteClientStateChangedNotification
     object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKRemoteClientStateChangedNotification object:nil];
}

-(void)doStartCasting{

	//Initiate call to user
	[ShowKit initiateCallWithSubscriber:@"623.viewer"];
	
	//Hide navbar
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	//Show calling overlay
	[self callStatusHidden:NO];

}

-(void)callStatusHidden: (BOOL)hidden{

	if(hidden == YES) {
	
	[UIView animateWithDuration:0.3
		delay: 0.0
		options:UIViewAnimationOptionCurveEaseOut
		animations:^{
           _callStatus.alpha = 0.0;
       }
        completion:^(BOOL finished){
           _callStatus.hidden = YES;
	}];
		
	} else if (hidden == NO){
	
	_callStatus.hidden = NO;
	
	[UIView animateWithDuration:0.3
		delay:0.0
		options:UIViewAnimationOptionCurveEaseOut
		animations:^{
           _callStatus.alpha = 0.94;
		}completion:^(BOOL finished){
           //do something on complete
	}];
	
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (void) connectionStateChanged: (NSNotification*) n
{
    SHKNotification* s ;
    NSString * v ;
    
    s = (SHKNotification*) [n object];
    v = (NSString*)s.Value;
    
    if ([v isEqualToString:SHKConnectionStatusCallTerminated]){
        //call is terminated
		
    } else if ([v isEqualToString:SHKConnectionStatusInCall]) {
		
		//When the viewer accepts the call, hide all the elements that aren't needed
		//Show calling overlay
		[self callStatusHidden:YES];
		
		//Show hangup button
		_hangUp.hidden=NO;
		
		//Set Screen as input device
        [ShowKit setState: SHKVideoInputDeviceScreen forKey: SHKVideoInputDeviceKey]; //share your screen
		//[ShowKit setState: SHKVideoInputDeviceFPS15 forKey: SHKVideoInputDeviceFPSKey];
		//[ShowKit setState:SHKGestureCaptureModeBroadcast forKey:SHKGestureCaptureModeKey];
		
    }else if ([v isEqualToString:SHKConnectionStatusCallFailed]) {
        
		//Call failed to connect
		[self callStatusHidden:NO];
		
		//Show hangup button
		_hangUp.hidden=YES;
	}
}

- (void) remoteClientStatusChanged: (NSNotification*) n
{
    SHKNotification* s;
    NSString*        status;
    
    s = (SHKNotification*) [n object];
    status = (NSString*)s.Value;
    
    NSLog(@"Remote client status changed: %@", status);
    
//    if ([status isEqualToString:SHKRemoteClientGestureStateStarted]) {
//        NSLog(@"Remote Client Gesture Started");
//        [ShowKit setState:SHKGestureCaptureModeReceive
//                   forKey:SHKGestureCaptureModeKey]; //allow incoming gestures!!
//    }
}

- (IBAction)hangUpCall {
    
	//Hang up the call
	[ShowKit hangupCall];
	
	//Hide hangup button
	_hangUp.hidden=YES;
	
	//Show navbar
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	//Hide overlay if its not already
	[self callStatusHidden:YES];
}

@end
