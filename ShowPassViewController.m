//
//  ShowPassViewController.m
//  GymPass
//
//  Created by john.neyer on 4/18/14.
//  Copyright (c) 2014 John Neyer. All rights reserved.
//

#import "ShowPassViewController.h"

#import "RSCodeGen.h"
#import "Constants.h"

@interface ShowPassViewController ()

@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeCodeLabel;

@end

@implementation ShowPassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showPass];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) showPass
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self.memberNameLabel setText:self.memberName];
    [self.memberIdLabel setText:self.memberId];
    [self.venueLabel setText:self.venueName];
    
    UIImage * generatedImage = [CodeGen genCodeWithContents:self.memberId machineReadableCodeObjectType:RSMetadataObjectTypeExtendedCode39Code];
    [self.barcodeCodeLabel setText:self.memberId];
    
    [self.barcodeImageView setImage:generatedImage];
    
    [self.passView setBackgroundColor:kCOLOR_RED];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)infoButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
