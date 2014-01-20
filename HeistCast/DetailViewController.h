//
//  DetailViewController.h
//  HeistCast
//
//  Created by David Stubbs on 1/15/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *startCasting;
@property (nonatomic,weak) IBOutlet UIView *callStatus;
@property (nonatomic,weak) IBOutlet UILabel *callStatusLabel;
@property (nonatomic,weak) IBOutlet UIButton *hangUp;
@property (nonatomic,weak) IBOutlet UIButton *hangupBeforeCall;

-(IBAction)doStartCasting;
-(IBAction)hangUpCall;

@end
