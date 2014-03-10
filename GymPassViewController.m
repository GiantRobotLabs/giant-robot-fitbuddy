//
//  GymPassViewController.m
//  FitBuddy
//
//  Created by john.neyer on 3/7/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "GymPassViewController.h"
#import "Constants.h"
#import <PassKit/PassKit.h>

@interface GymPassViewController ()
{
 
}

@end

@implementation GymPassViewController

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
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    [self.makeAPassButton setBackgroundColor:kCOLOR_RED];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:TRUE];
    
    self.memberNameField.returnKeyType = UIReturnKeyDone;
    self.memberNumberField.returnKeyType = UIReturnKeyDone;
    self.locationNameField.returnKeyType = UIReturnKeyDone;
    
    if (![PKPassLibrary isPassLibraryAvailable]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Library Error" message:@"The Pass Library is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    PKPassLibrary *passLib = [[PKPassLibrary alloc] init];
    
    
    PKPass *pass = [passLib passWithPassTypeIdentifier:@"pass.com.giantrobotlabs.fitbuddy" serialNumber:@"000000001"];
    
    if (pass)
    {
        [self.memberNameField setText:[pass localizedValueForFieldKey:@"member"]];
        [self.memberNumberField setText:[pass localizedValueForFieldKey:@"memberId"]];
        [self.locationNameField setText:[pass localizedValueForFieldKey:@"membership"]];
        
        [self.makeAPassButton setTitle:@"Update Gym Pass" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.makeAPassButton setTitle:@"Add Gym Pass" forState:UIControlStateNormal];

    }
    
    if (self.venue)
    {
        [self.locationNameField setText:self.venue.name];
    }
    
    [self.locationTable reloadData];
    
}

-(IBAction)textFieldEditingDidEnd:(id)sender
{
    UITextField *theField = (UITextField*)sender;
    // do whatever you want with this text field
    [theField resignFirstResponder];
}

- (IBAction)makePassButtonClicked:(id)sender
{
    NSLog(@"Preparing Gym Pass for: Name:%@, Id:%@, Venue:%@, Addr:%@, Lat:%@, Lon:%@",
          self.memberNameField.text,
          self.memberNumberField.text,
          self.locationNameField.text,
          self.venue.location.address,
          [NSNumber numberWithDouble: self.venue.location.coordinate.latitude],
          [NSNumber numberWithDouble: self.venue.location.coordinate.longitude]);
    
    if (self.memberNumberField.text && self.memberNumberField.text && self.locationNameField.text)
    {
        NSString *service = @"https://sinatra-evilsushi.rhcloud.com/passbook";
        NSString *name = self.memberNameField.text;
        NSString *memberId = self.memberNumberField.text;
        NSString *locName = self.locationNameField.text;
        NSString *address = @"No address";
        NSNumber *lat = [NSNumber numberWithDouble:0.0];
        NSNumber *lon = [NSNumber numberWithDouble:0.0];
        
        if (self.venue)
        {
            lat = [NSNumber numberWithDouble: self.venue.location.coordinate.latitude];
            lon = [NSNumber numberWithDouble: self.venue.location.coordinate.longitude];
            
            address = self.venue.location.address;
            
            if (address == nil || address.length == 0)
            {
                address = [NSString stringWithFormat:@"%@, %@", lat, lon];
            }
            
        }
        
        NSString *serviceString = [NSString stringWithFormat:@"%@?memberName=%@&memberId=%@&locationName=%@&locationAddress=%@&locationLat=%@&locationLon=%@", service, name, memberId, locName, address, lat, lon];
        
        NSURL *serviceURL = [NSURL URLWithString:[serviceString stringByAddingPercentEscapesUsingEncoding:
                                                  NSASCIIStringEncoding]];
        
        UIActivityIndicatorView *activityView = [self showActivityIndicatorOnView:self.view];
        NSData *data = [NSData dataWithContentsOfURL:serviceURL];
        [activityView stopAnimating];
        
        [self showPass:data];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing information" message:@"You must complete the form fields to generate a pass." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
 
}

- (void) showPass: (NSData *) data
{
    NSError *err;
    if (nil != data)
    {
        PKPass *pass = [[PKPass alloc] initWithData:data error:&err];
        
        
        
        if (err)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            PKAddPassesViewController *pkvc = [[PKAddPassesViewController alloc] initWithPass:pass];
            
            [self presentViewController:pkvc
                               animated:YES
                             completion:nil                 ];
        }
    }

}

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // other size? change it
    activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.alpha = 0.7f;
    activityIndicatorView.backgroundColor = kCOLOR_GRAY_t;
    activityIndicatorView.layer.cornerRadius = 10.0f;
    
    // display it in the center of your view
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    [activityIndicatorView setHidesWhenStopped:YES];
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setValue:self.locationNameField.text forKey:@"searchString"];
    [segue.destinationViewController setValue:self forKey:@"parent"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GymPassLocationCell"];
    UILabel *venueLabel = cell.textLabel;
    UILabel *addressLabel = cell.detailTextLabel;
    
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];

    if (self.venue)
    {
        [venueLabel setText:self.venue.name];
        [addressLabel setText:self.venue.location.address];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [venueLabel setText:@"No Location"];
        [addressLabel setText:@""];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    [labelView setBackgroundColor: kCOLOR_LTGRAY];
    [labelView setAutoresizesSubviews:TRUE];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width, 40.0)];
    label.text = [sectionTitle uppercaseString];
    label.font = [UIFont systemFontOfSize:14.0];
    [label setTextColor: kCOLOR_DKGRAY];
    
    [labelView addSubview:label];
    
    return labelView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Membership Location";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showMapSeque" sender:self];
    
}

@end
