
//
//  LogbookViewController.m
//  GymBuddy
//
//  Created by John Neyer on 2/12/12.
//  Copyright (c) 2012 jneyer.com. All rights reserved.
//

#import "LogbookViewController.h"
#import "FitBuddyMacros.h"
#import "BarChartDataSource.h"
#import "JBChartView.h"

#import "FitBuddy-Swift.h"

@implementation LogbookViewController
{
    JBBarChartView *chart;
    NSFetchedResultsController *chartDataSource;
    NSMutableArray *entries;
    BarChartDataSource *chartData;
    BOOL frameLoaded;
}

@synthesize logbookEntry = _logbookEntry;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFITBUDDY]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupFetchedResultsController) name:kUBIQUITYCHANGED object:nil];
    
    entries = [[NSMutableArray alloc]init];
    
    
}

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:LOGBOOK_TABLE];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO selector:@selector(compare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"completed = %@", [NSNumber numberWithBool:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext: [[AppDelegate sharedAppDelegate]managedObjectContext]
                                                                          sectionNameKeyPath:@"date_t"
                                                                                   cacheName:nil];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

-(void) viewDidAppear:(BOOL)animated
{
    if (chartData == nil)
    {
        chartData = [[BarChartDataSource alloc] init];
    }
    
    [chartData load];
    [self prepareChart];
    [chart reloadData];
    
    [super viewDidAppear:animated];

    CGRect footerframe = chart.footerView.frame;
    footerframe.origin.y = footerframe.origin.y + 20;
    [chart.footerView setFrame: footerframe];
    
}

- (void) prepareChart
{
    if (chart == nil)
    {
        chart = [[JBBarChartView alloc]init];
        [chart setDelegate:chartData];
        [chart setDataSource:chartData];
        
        [self addSubview:chart fillingAndInsertedIntoView:self.chartView];
    
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, ceil(chart.bounds.size.height * 0.5) - ceil(80.0f * 0.5), chart.bounds.size.width - (10.0f * 2), 80.0f)];
        headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 14)];
        
        [headerView setText: [@"30 Day Activity Profile" uppercaseString]];
        [headerView setTextAlignment:NSTextAlignmentCenter];
        [headerView setTextColor: kCOLOR_DKGRAY];
        [headerView setFont:[UIFont fontWithName:headerView.font.fontName size:14.0f]];
        chart.headerView = headerView;
        
        [chart setHeaderPadding:10.0f];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        
        NSString *rightDate = [dateFormat stringFromDate:[[NSDate alloc] init]];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 400, chart.bounds.size.width - (10.0f * 2), 40.0f)];
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,12)];
        [rightLabel setText: [rightDate uppercaseString]];
        [rightLabel setTextAlignment:NSTextAlignmentRight];
        [rightLabel setTextColor: [UIColor blackColor]];
        [rightLabel setFont:[UIFont fontWithName:rightLabel.font.fontName size:12.0f]];
        chart.footerView = rightLabel;
        
        [chart layoutIfNeeded];

    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Logbook Cell"];
    UILabel *exerciseLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *workoutLabel = (UILabel *) [cell viewWithTag:101];
    UIImageView *exerciseIcon = (UIImageView *) [cell viewWithTag:102];
    UILabel *qstatValue = (UILabel *) [cell viewWithTag:103];
    UILabel *qstatLabel = (UILabel *) [cell viewWithTag:104];
    
    // Add the data to the cell
    LogbookEntry *logbookEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [entries addObject:logbookEntry];

    exerciseLabel.text = logbookEntry.exercise_name;
    workoutLabel.text = logbookEntry.workout_name;
    
    if (logbookEntry.pace || logbookEntry.distance || logbookEntry.duration)
    {
        exerciseIcon.image = [UIImage imageNamed:kCARDIO];
        qstatLabel.text = @"Pace";
        qstatValue.text = logbookEntry.pace;
    }
    else
    {
        exerciseIcon.image = [UIImage imageNamed:kRESISTANCE];
        qstatLabel.text = @"Weight";
        qstatValue.text = logbookEntry.weight;
    }
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if (DEBUG) NSLog(@"Segue: %@", segue.identifier);
    
    LogbookEntry *entry = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if ([segue.destinationViewController respondsToSelector:@selector(setLogbookEntry:)]) {
        [segue.destinationViewController performSelector:@selector(setLogbookEntry:) withObject:entry];
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return YES to edit
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        //Check if index path is valid
        if(indexPath)
        {
            //Get the cell out of the table view
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            //Update the cell or model 
            cell.editing = YES;
            LogbookEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [[AppDelegate sharedAppDelegate].managedObjectContext deleteObject:entry];
        }
    }    
}

-(NSString *) convertRawToShortDateString: (NSString *) rawDateStr
{
    // Convert rawDateStr string to NSDate...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];
    NSDate *date = [formatter dateFromString:rawDateStr];
    
    // Convert NSDate to format we want...
    [formatter setDateFormat:@"dd MMMM yyyy"];
    NSString *formattedDateStr = [formatter stringFromDate:date];
    return formattedDateStr;  
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
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = [[self convertRawToShortDateString:sectionTitle] capitalizedString];
    [label setTextColor: kCOLOR_DKGRAY];

    [labelView addSubview:label];
    
    return labelView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

#pragma mark - JBChartView Delegate
- (void)addSubview:(UIView *)insertedView fillingAndInsertedIntoView:(UIView *)containerView {
    
    [containerView addSubview:insertedView];
    [insertedView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[insertedView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(insertedView)]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[insertedView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(insertedView)]];
    
    [containerView layoutIfNeeded];
}


@end
