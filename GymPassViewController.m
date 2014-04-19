//
//  GymPassViewController.m
//  FitBuddy
//
//  Created by john.neyer on 3/7/14.
//  Copyright (c) 2014 jneyer.com. All rights reserved.
//

#import "GymBuddyAppDelegate.h"
#import "GymPassViewController.h"
#import "Constants.h"
#import "FoursquareConstants.h"

#import "ShowPassViewController.h"

@interface GymPassViewController ()
{
    BOOL loaded;
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
    [self.makeAPassButton setTitleColor:kCOLOR_LTGRAY forState:UIControlStateHighlighted];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:TRUE];
    
    self.memberNameField.returnKeyType = UIReturnKeyDone;
    self.memberNumberField.returnKeyType = UIReturnKeyDone;
    self.locationNameField.returnKeyType = UIReturnKeyDone;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [defaults objectForKey:kDEFAULTS_NAME];
    NSString *uid = [defaults objectForKey:kDEFAULTS_ID];
    NSString *locname = [defaults objectForKey:kDEFAULTS_LOCNAME];
    
    [self.memberNameField setText:name];
    [self.memberNumberField setText:uid];
    [self.locationNameField setText:locname];
    
    [self.makeAPassButton setTitle:@"Show Gym Pass" forState:UIControlStateNormal];
    
    if (self.venue)
    {
        [self.locationNameField setText:self.venue.name];
    }
    
    [self.locationTable reloadData];
    
    [[GymBuddyAppDelegate sharedAppDelegate] setGymPassViewController:self];
    
    if ([self validateFields])
    {
        loaded = YES;
        [self showPass:YES];
    }
    
}

-(IBAction)textFieldEditingDidEnd:(id)sender
{
    UITextField *theField = (UITextField*)sender;
    // do whatever you want with this text field
    [self saveDefaults];
    
    [theField resignFirstResponder];
}

- (void) saveDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.memberNameField.text forKey:kDEFAULTS_NAME];
    [defaults setObject:self.memberNumberField.text forKey:kDEFAULTS_ID];
    [defaults setObject:self.locationNameField.text forKey:kDEFAULTS_LOCNAME];
    [defaults synchronize];
}

- (BOOL) validateFields
{
    return ([self.memberNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 && [self.memberNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 && [self.locationNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0);
}

- (IBAction)makePassButtonClicked:(id)sender
{
    [self saveDefaults];
    
    if (DEBUG) NSLog(@"Preparing Gym Pass for: Name:%@, Id:%@, Venue:%@, Addr:%@, Lat:%@, Lon:%@",
                     self.memberNameField.text,
                     self.memberNumberField.text,
                     self.locationNameField.text,
                     self.venue.location.address,
                     [NSNumber numberWithDouble: self.venue.location.coordinate.latitude],
                     [NSNumber numberWithDouble: self.venue.location.coordinate.longitude]);
    
    if ([self validateFields])
    {
        
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
        
        [self showPass:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No information entered" message:@"Please provide your name, ID, and location name to generate a Gym Pass." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void) showPass: (BOOL) animated
{
    if (animated)
    {
        [self performSegueWithIdentifier:@"ShowGymPass" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowGymPassNoAnimation" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"ShowGymPass"])
    {
        ShowPassViewController *passViewController = (ShowPassViewController *)segue.destinationViewController;
        [passViewController setMemberId:self.memberNumberField.text];
        [passViewController setMemberName:self.memberNameField.text];
        [passViewController setVenueName:self.locationNameField.text];
    }
    else
    {
        [segue.destinationViewController setValue:self.locationNameField.text forKey:@"searchString"];
        [segue.destinationViewController setValue:self forKey:@"parent"];
    }
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
        [venueLabel setText:@"Gym Search"];
        [addressLabel setText:@"Tap to search for gym location name."];
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

- (void)viewDidDisappear:(BOOL)animated
{
    [[GymBuddyAppDelegate sharedAppDelegate] setGymPassViewController:nil];
}

@end
