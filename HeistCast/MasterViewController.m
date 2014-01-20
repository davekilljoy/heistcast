#import "MasterViewController.h"
#import "DetailViewController.h"
#import <ShowKit/ShowKit.h>

NSString *jsonURL = @"https://heistcast.firebaseio.com/.json";

@implementation MasterViewController
{
	NSDictionary *_items;
	//NSString *_refreshContol;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIColor *bgRefreshColor = [UIColor colorWithRed:95/255.0f green:167/255.0f blue:192/255.0f alpha:1.0f];
	UIColor *tintColor = [UIColor whiteColor];
		
	//Set the title of the page
	self.title = @"PROTOTYPES";
	
	//Get the JSON
	[self getJSON];
	
	//Pull to refresh code
	//Create the pull to refresh element
	UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
	
	[refresh addTarget:self
	action:@selector(refreshView:)
	forControlEvents:UIControlEventValueChanged];
	[refresh setTintColor:tintColor];
	[refresh setBackgroundColor:bgRefreshColor];
		
	self.refreshControl = refresh;
}
 -(void)refreshView:(UIRefreshControl *)refresh {
     
	//Start refreshing the data with new JSON
	[self getJSON];
		
	NSLog(@"%@",_items);
	
	//Tell the control its done refreshing
	[refresh endRefreshing];
	
	//Update the data in the table view
	[self.tableView reloadData];
}
-(void)getJSON
{
	//Input JSON URL and format it as a URL
    NSURL *url = [NSURL URLWithString: jsonURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL: url];
	
	//Set the network activity indicator to on
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [NSURLConnection connectionWithRequest: requestObj
		delegate: self];
	
	NSError *error;
	NSData *data = [NSData dataWithContentsOfURL: url];
	_items = [NSJSONSerialization JSONObjectWithData: data
		options: NSJSONReadingAllowFragments
		error: &error];
		
	if (_items == [NSNull null]){

		_items = nil;
		
		[self _setEmptyViewHidden:NO];
		
	} else {
		
		[self _setEmptyViewHidden:YES];
	
	}
	
	//Log returned JSON
	//NSLog(@"%@",_items);
		
	if (error != nil)
	{
		NSLog(@"Error: %@", error);
	}
}

#pragma mark - Table View

//Table View stuff

- (void)_setEmptyViewHidden: (BOOL)hidden
{
	if (hidden == YES && _emptyView.superview != nil){
		
		[_emptyView removeFromSuperview];
		
	}else if (hidden == NO && _emptyView.superview == nil){
	
		CGRect frame = _emptyView.frame;
		frame.origin.x = (self.tableView.frame.size.width - frame.size.width) / 2.f;
		frame.origin.y = 16.f;
		
		UIImage *image = [UIImage imageNamed:@"emptyList.png"];
		_emptyView = [[UIImageView alloc] initWithImage:image];
		
		[self.tableView addSubview: _emptyView];
		[self.tableView bringSubviewToFront: _emptyView];
	
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView: (UITableView *)tableView
	numberOfRowsInSection: (NSInteger)section
{

	return _items.count;

}

- (UITableViewCell *)tableView: (UITableView *)tableView
	cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"
		forIndexPath: indexPath];
	
	//Get Dictionary of returned JSON items and look for only the "title" row
	NSDictionary *item = [[_items allValues] objectAtIndex: indexPath.row];
	
	//Set new font
	cell.textLabel.font = [UIFont fontWithName:@"FreightSansMedium" size:18];
	
	//Set row text with "title" text
	cell.textLabel.text = [item objectForKey: @"title"];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	return cell;
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue
	sender: (id)sender
{
    if ([[segue identifier] isEqualToString: @"showDetail"])
	{

		//Get selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		
		//Get the object reference ID for the selected row and create a dictionary
        NSDictionary *object = [[_items allValues] objectAtIndex: indexPath.row];
        
		//Pass the string to the webView controller on the details screen
		[[segue destinationViewController]
			setDetailItem: object];
    }
}

-(void)doLogoutButton:(id)sender{
	[ShowKit logout];
	
	[self performSegueWithIdentifier:@"presenterLogout" sender:self];
	
	NSLog(@"%@",@"Logged Out");
}

@end
