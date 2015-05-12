//
//  SettingsIncrementViewController.swift
//  FitBuddy
//
//  Created by John Neyer on 5/11/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import UIKit
import FitBuddyCommon

class SettingsIncrementViewController : UIViewController, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var settingsKey : NSString?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var pickerValues : NSMutableArray = []
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var spinnerTitle: UILabel!
    
    func setPickerValues (values: NSArray, defaultValue: String) {
        pickerValues = values.mutableCopy() as! NSMutableArray
    }
    
    func setDefaultsKey (defaultsKey: String) {
        settingsKey = defaultsKey
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerValues[row] as! String
    }
    
    override
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPickerFromDefaults()
        self.spinnerTitle.text = self.settingsKey! as String
    }
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: FBConstants.kFITBUDDY))
    }
    
    func loadPickerFromDefaults() {
        
        if let value = self.userDefaults.stringForKey(self.settingsKey! as String) {
            let index = self.pickerValues.indexOfObject(value)
            self.picker.selectRow(index, inComponent: 0, animated: true)
        }
        else {
            self.picker.selectRow(0, inComponent: 0, animated: true)
        }
    }

    @IBAction func confirmChange(sender: AnyObject) {
        
        let index = self.picker.selectedRowInComponent(0)
        let value = self.pickerValues[index] as! String
        
        if self.settingsKey == FBConstants.kEXPORTDBKEY {
            self.handleExportToggle(value)
            self.exit()
        }
        
        let defValue = self.userDefaults.stringForKey(self.settingsKey as! String)
        
        if  defValue != value {
            
            self.userDefaults.setObject(value, forKey: self.settingsKey! as String)
            
            if self.settingsKey == FBConstants.kUSEICLOUDKEY {
                self.handleiCloudToggle(value)
            }
            else {
                self.exit()
            }
        }
        else {
            self.exit()
        }
    }
    
    func handleExportToggle(exportType : String) {
        AppDelegate.sharedAppDelegate().modelManager.exportData(FBConstants.kITUNES)
    }
    
    func handleiCloudToggle (value: String) {
        FitBuddyUtils.setCloudOn(value == "Yes" ? true : false)
        self.exit()
    }

    func exit () {
        self.userDefaults.synchronize()
        AppDelegate.sharedAppDelegate().syncSharedDefaults()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}


/*


#pragma mark - Export Options
- (void) handleExportToggle: (NSString *) exportType
{
    [[AppDelegate sharedAppDelegate].modelManager exportData:exportType];
}

#pragma mark - iCloud Handler
- (void) handleiCloudToggle: (NSString *) value
{
    
    [self.defaults setObject:value forKey:kUSEICLOUDKEY];
    return;
    
    if ([value isEqualToString:kYES])
    {
        if ([[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle: @"Can't activate iCloud"
            message: @"It doesn't look like iCloud is enabled on this device. Please go to the Settings app to make sure your iCloud account is set up and active."
            delegate: nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
            [alert show];
            
            [self.defaults setObject:@"No" forKey:self.defaultsKey];
            [self.defaults synchronize];
            [self loadPickerFromDefaults];
            
        }
        else if ([self iCloudExists])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle: @"Switching to iCloud"
            message: @"It looks like there is already FitBuddy data in iCloud. Would you like to recover or replace the iCloud workout data."
            delegate: self
            cancelButtonTitle:@"Recover"
            otherButtonTitles:@"Replace", nil];
            [alert show];
        }
        else
        {
            [self migrateLocalToiCloudWithRecovery:YES];
        }
    }
    else if ([value isEqualToString:kNO])
    {
        [self migrateiCloudToLocal];
    }
}

-(void)alertView:(UIAlertView *)alert_view didDismissWithButtonIndex:(NSInteger)button_index
{
    if (button_index == 0)
    {
        NSLog (@"Recover");
        [self migrateLocalToiCloudWithRecovery:YES];
    }
    else if (button_index == 1)
    {
        NSLog(@"Replace");
        
        [self migrateLocalToiCloudWithRecovery:NO];
    }
}

-(BOOL) migrateLocalToiCloudWithRecovery: (BOOL) recover
{
    NSError *err;
    
    NSDictionary *options = [[CoreDataConnection defaultConnection] defaultStoreOptions:YES];
    [self waitForiCloudResponse];
    
    NSPersistentStore *oldstore = [[AppDelegate sharedAppDelegate]. persistentStoreCoordinator.persistentStores lastObject];
    
    if (recover)
    {
        
        [[[AppDelegate sharedAppDelegate] persistentStoreCoordinator] removePersistentStore:oldstore error:&err];
        
        if (err)
        {
            NSLog(@"Failed to replace Cloud store with Local store: %@", err);
            
            return FALSE;
        }
    }
    else
    {
        [[AppDelegate sharedAppDelegate].persistentStoreCoordinator migratePersistentStore:oldstore toURL:[[AppDelegate sharedAppDelegate] theLocalStore] options:options withType:NSSQLiteStoreType error:&err];
        
        if (err)
        {
            NSLog(@"Failed to migrate Local to iCloud store: %@", err);
            return FALSE;
        }
    }
    
    return TRUE;
}

-(BOOL) migrateiCloudToLocal
    {
        NSError *err;
        NSDictionary *options = [[CoreDataConnection defaultConnection] defaultStoreOptions:NO];
        
        [self waitForiCloudResponse];
        
        NSPersistentStore *oldstore = [[AppDelegate sharedAppDelegate]. persistentStoreCoordinator.persistentStores lastObject];
        
        // [CoreDataHelper moveLocalStoreToBackup];
        
        NSPersistentStoreCoordinator *psc = [AppDelegate sharedAppDelegate].persistentStoreCoordinator;
        
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[AppDelegate sharedAppDelegate] theLocalStore] options:options error:&err];
        
        if (err)
        {
            NSLog(@"Failed to migrate iCloud to local store: %@", err);
            return FALSE;
        }
        
        [self exit];
        return TRUE;
}

-(BOOL) iCloudExists
    {
        //TODO: determine if icloud exists
        
        return FALSE;
    }
    
    - (void) waitForiCloudResponse
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudDidRespond:) name:kUBIQUITYCHANGED object:[AppDelegate sharedAppDelegate]];
            [self showActivityIndicatorOnView:self.tabBarController.view.superview];
            [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:FALSE];
        }
        
        - (void) cloudDidRespond: (id) sender
{
    NSLog(@"response from icloud");
    
    [activityIndicatorView stopAnimating];
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:TRUE];
    activityIndicatorView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self exit];
    }
    
    - (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    activityIndicatorView = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // other size? change it
    activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.alpha = 0.7f;
    activityIndicatorView.backgroundColor = kCOLOR_GRAY_t;
    activityIndicatorView.layer.cornerRadius = 10.0f;
    
    // display it in the center of your view
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}
*/
