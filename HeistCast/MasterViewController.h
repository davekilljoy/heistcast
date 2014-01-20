//
//  MasterViewController.h
//  HeistCast
//
//  Created by David Stubbs on 1/15/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *emptyView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *logoutButton;

-(IBAction)doLogoutButton:(id)sender;

@end
