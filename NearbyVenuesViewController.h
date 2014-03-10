//
//  NearbyVenuesViewController.h
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 1/20/13.
//
//

#import <UIKit/UIKit.h>

@interface NearbyVenuesViewController :UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) UIViewController *parent;

@end
