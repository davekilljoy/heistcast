//
//  LoginModalViewController.h
//  HeistCast
//
//  Created by David Stubbs on 1/15/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginModalViewController : UIViewController

@property (strong, nonatomic) id sender;
@property (nonatomic, weak) IBOutlet UIButton *presenterButton;
@property (nonatomic, weak) IBOutlet UIButton *viewerButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) IBOutlet UIImageView *heistLogo;

-(IBAction)doPresenterButton;
-(IBAction)doViewerButton;

@end
