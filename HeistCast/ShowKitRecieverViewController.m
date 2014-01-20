//
//  ShowKitRecieverViewController.m
//  HeistCast
//
//  Created by David Stubbs on 1/18/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import "ShowKitRecieverViewController.h"
#import <ShowKit/ShowKit.h>

@interface ShowKitRecieverViewController ()

@end

@implementation ShowKitRecieverViewController

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

	//Set status bar color to black
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	
	//Button stuff
	UIImage *btnImage = [UIImage imageNamed:@"buttonBorder.png"];
	UIImage *newImg = [btnImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	UIImage *btnPressedImage = [UIImage imageNamed:@"buttonBody.png"];
	UIImage *newPressedImg = [btnPressedImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	[_logoutButton setBackgroundImage:newImg forState:UIControlStateNormal];
	[_logoutButton setBackgroundImage:newPressedImg forState:UIControlStateHighlighted];
	
	_logoutButton.titleLabel.font = [UIFont fontWithName:@"FreightSansMedium" size:16.f];
	
	_displayText.font = [UIFont fontWithName:@"FreightSansBook" size:30.f];
	
	//ShowKit Stuff
	//Check ShowKit notifications
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(connectionStateChanged:)
		name:SHKConnectionStatusChangedNotification
		object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [ShowKit setState:SHKVideoScaleModeFit forKey:SHKVideoScaleModeKey]; //ensure that you can see the whole view.
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
    [ShowKit setState:SHKGestureCaptureLocalIndicatorsOn forKey:SHKGestureCaptureLocalIndicatorsModeKey];
    [ShowKit setState:self.displayView forKey:SHKMainDisplayViewKey];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [ShowKit setState:nil forKey:SHKMainDisplayViewKey];
}

//-(void)isAudioMuted: (BOOL)muted{
//
//	if(muted == YES){
//	
//		[ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
//		
//	} else if (muted ==NO){
//	
//		[ShowKit setState: SHKAudioInputModeRecording forKey: SHKAudioInputModeKey];
//	
//	}
//}

- (void) remoteClientStatusChanged: (NSNotification*) n
{
#ifdef DEBUG_OUT
    NSLog(@"%@.remoteClientStatusChanged called on: %@ onMainThread: %d", [self class], device.name, [NSThread isMainThread]);
#endif
    SHKNotification* s;
    NSString*        status;
    
    s = (SHKNotification*) [n object];
    status = (NSString*)s.Value;
    
    if ([status isEqualToString:SHKRemoteClientVideoStateStarted]){
        NSLog(@"%@.remoteClientStatusChanged SHKRemoteClientVideoStateStarted", [self class]);
//        [ShowKit setState:SHKGestureCaptureModeBroadcast
//                   forKey:SHKGestureCaptureModeKey];
		
        NSLog(@"%@.connectionStateChanged SHKGestureCaptureModeBroadcast", [self class]);
        
    } else if ([status isEqualToString:SHKRemoteClientVideoStateStopped]) {
        NSLog(@"%@.remoteClientStatusChanged SHKRemoteClientVideoStateStopped", [self class]);
		[self.navigationController setNavigationBarHidden:NO animated:YES];
    } else if ([status isEqualToString:SHKRemoteClientAudioStateStarted]) {
        NSLog(@"%@.remoteClientStatusChanged SHKRemoteClientAudioStateStarted", [self class]);
    } else if ([status isEqualToString:SHKRemoteClientAudioStateStopped]) {
        NSLog(@"%@.remoteClientStatusChanged SHKRemoteClientAudioStateStopped", [self class]);
    } else if ([status isEqualToString:SHKRemoteClientGestureStateStarted]) {
        NSLog(@"%@.remoteClientStatusChanged SHKRemoteClientGestureStateStarted", [self class]);
    } else if ([status isEqualToString:SHKRemoteClientGestureStateStopped]) {
        NSLog(@"%@.remoteClientStatusChanged SHKRemoteClientGestureStateStopped", [self class]); 
    }
}

- (void) connectionStateChanged: (NSNotification*) n
{
    SHKNotification* s ;
    NSString * v ;
    
    s = (SHKNotification*) [n object];
    v = (NSString*)s.Value;
    
    if ([v isEqualToString:SHKConnectionStatusCallTerminated]){

        //call is terminated
		_logoutButton.hidden=NO;
		
    } else if ([v isEqualToString:SHKConnectionStatusInCall]) {
        //start gesture sharing
//        [ShowKit setState:SHKGestureCaptureModeBroadcast
//                   forKey:SHKGestureCaptureModeKey];
//        NSLog(@"%@.connectionStateChanged SHKGestureCaptureModeBroadcast", [self class]);
		
//		[ShowKit setState:SHKGestureCaptureLocalIndicatorsOn forKey:SHKGestureCaptureLocalIndicatorsModeKey];
//
//		[ShowKit setState:SHKGestureCaptureModeReceive forKey:SHKGestureCaptureModeKey];

		//Mute audio for viewer
		[ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];

		_logoutButton.hidden=YES;
       
    } else if ([v isEqualToString:SHKConnectionStatusCallIncoming]) {
	
        [ShowKit setState: SHKVideoInputDeviceNone forKey: SHKVideoInputDeviceKey]; // Don't show your camera to the user
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Incoming Call"
												message:@"Do you want to accept this call?"
                                                delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
        [message show];
		
		if([UIApplication sharedApplication].applicationState  == UIApplicationStateBackground)
			{
          //if the application is in the background, show the user a localnotification
          UILocalNotification* ln = [[UILocalNotification alloc] init];
          ln.fireDate = [NSDate date];
          ln.alertBody = [NSString stringWithFormat:@"Incoming call from Presenter"];
          ln.soundName = @"ring.wav";
          [[UIApplication sharedApplication] cancelAllLocalNotifications];
          [[UIApplication sharedApplication] scheduleLocalNotification:ln];
      } else {
          //otherwise lets play a ringing tone.
          //[self->m_AVPlayer play];
      }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Yes"]) {
        [ShowKit acceptCall];
    } else {
        [ShowKit rejectCall];
    }
}

-(void)doLogoutButton:(id)sender{
	[ShowKit logout];
	NSLog(@"%@",@"Logged Out");
}

@end
