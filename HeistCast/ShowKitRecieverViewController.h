//
//  ShowKitRecieverViewController.h
//  HeistCast
//
//  Created by David Stubbs on 1/18/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowKitRecieverViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIView *displayView;
@property(nonatomic,weak) IBOutlet UILabel *displayText;
@property(nonatomic,weak) IBOutlet UIButton *logoutButton;

-(IBAction)doLogoutButton:(id)sender;

@end
