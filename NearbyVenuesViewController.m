//
//  NearbyVenuesViewController.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 1/20/13.
//
//

#import "NearbyVenuesViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "Constants.h"
#import "FoursquareConstants.h"

@interface NearbyVenuesViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) FSVenue *selected;
@property (strong, nonatomic) NSArray *nearbyVenues;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NearbyVenuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.mapView setShowsBuildings:YES];
    [self.mapView setShowsUserLocation:YES];
    
    self.title = @"Nearby Gyms";
}

- (void)removeAllAnnotationExceptOfCurrentUser {
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
    if ([self.mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:self.mapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in self.mapView.annotations) {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [self.mapView removeAnnotations:annForRemove];
}

- (void)proccessAnnotations {
    [self removeAllAnnotationExceptOfCurrentUser];
    [self.mapView addAnnotations:self.nearbyVenues];
}



- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:self.searchString
                                     limit:nil
                                    intent:intentBrowse
                                    radius:@(32000)
                                categoryId:kFSCATEGORYID
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyVenues = [converter convertToObjects:venues];
                                          [self.tableView reloadData];
                                          [self proccessAnnotations];
                                          
                                      }
                                  }];
}

- (void)setupMapForLocation:(CLLocation *)newLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
    [self setupMapForLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyVenues.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.nearbyVenues.count) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    FSVenue *venue = self.nearbyVenues[indexPath.row];
    cell.textLabel.text = [venue name];
    if (venue.location.address) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@m)",
                                     venue.location.address, venue.location.distance];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                     venue.location.distance];
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)userDidSelectVenue {
    
    [self.mapView setCenterCoordinate:self.selected.location.coordinate animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selected = self.nearbyVenues[indexPath.row];
    [self userDidSelectVenue];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:s];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pinView.canShowCallout = YES;
        pinView.calloutOffset = CGPointMake(0, 0);
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        [button setTintColor:[UIColor whiteColor]];
        [button setBackgroundColor:kCOLOR_RED];
        [button setTitle:@"SELECT" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:button.titleLabel.font.fontName size:10.0f]];
        [button addTarget:self action:@selector(locationSelected) forControlEvents:UIControlEventTouchUpInside];
        [pinView setRightCalloutAccessoryView:button];
    }
    
    return pinView;
}

-(void) locationSelected
{
    [self.parent setValue:self.selected forKey:@"venue"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.selected.name forKey:kDEFAULTS_LOCNAME];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tap the pin to select a location.";
}

@end
