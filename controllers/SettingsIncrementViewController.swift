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
import FitBuddyModel

class SettingsIncrementViewController : UIViewController, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var settingsKey : String = ""
    var pickerValues : NSMutableArray = []
    
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    
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
        self.spinnerTitle.text = self.settingsKey
    }
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: FBConstants.kFITBUDDY))
    }
    
    func loadPickerFromDefaults() {
        
        if let value = FitBuddyUtils.getDefault(self.settingsKey) {
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
        
        let defValue = FitBuddyUtils.getDefault(self.settingsKey)
        
        if  defValue != value {
            
            FitBuddyUtils.setDefault(self.settingsKey, value: value)
            
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
    
    func exit () {
        AppDelegate.sharedAppDelegate().syncSharedDefaults()
        FitBuddyUtils.saveDefaults()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func handleiCloudToggle (value: String) {
        
        FitBuddyUtils.setCloudOn(value == "Yes" ? true : false)

        if value == FBConstants.kYES
        {
            if CoreDataHelper2.coreDataUbiquityURL() == nil {
                
                let alert = UIAlertView(title: "Can't activate iCloud", message: "It doesn't look like iCloud is enabled on this device. Please go to the Settings app to make sure your iCloud account is set up and active.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
                FitBuddyUtils.setCloudOn(false)
                FitBuddyUtils.saveDefaults()
                self.loadPickerFromDefaults()
            }
            else if self.cloudExists() {
                
                let alert = UIAlertView(title: "Switching to iCloud", message: "It looks like there is already FitBuddy data in iCloud. Would you like to recover or replace the iCloud workout data.", delegate: self, cancelButtonTitle: "Recover", otherButtonTitles: "Replace")
                alert.show()
            }
            else {
                self.migrateLocalToiCloudWithRecovery(true)
            }
        }
        else if value == FBConstants.kNO {
            self.migrateiCloudToLocal()
        }
        
        self.exit()
    }
    
    func cloudExists() -> Bool {
        //TODO: do something
        return false
    }
    
    func migrateLocalToiCloudWithRecovery(recovery: Bool) -> Bool {
        
        if recovery {
            NSLog("Recovering content from iCloud")
        }
        else {
            NSLog("Replacing content in iCloud")
        }
        
        var error : NSError? = nil
        
        let options = CoreDataConnection.defaultConnection.defaultStoreOptions(true)
        waitForiCloudResponse()
        
        let oldstore = AppDelegate.sharedAppDelegate().persistentStoreCoordinator!.persistentStores.last as! NSPersistentStore
        
        if recovery {
            
            AppDelegate.sharedAppDelegate().persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: CoreDataHelper2.coreDataUbiquityURL()!, options: options, error: &error)
            
            AppDelegate.sharedAppDelegate().persistentStoreCoordinator!.removePersistentStore(oldstore, error: &error)
            
            if error != nil {
                NSLog("Failed to replace Cloud store with Local store: %@", error!);
                return false
            }
            
        }
        else {
            
            AppDelegate.sharedAppDelegate().persistentStoreCoordinator!.migratePersistentStore(oldstore, toURL: CoreDataHelper2.coreDataUbiquityURL()!, options: options, withType: NSSQLiteStoreType, error: &error)
            
            if error != nil {
                NSLog("Failed to migrate Local to iCloud store: %@", error!);
                return false
            }
        }
        return true
    }
    
    func migrateiCloudToLocal ()  -> Bool {
        
        var error : NSError? = nil
        
        let options = CoreDataConnection.defaultConnection.defaultStoreOptions(false)
        waitForiCloudResponse()
        
        let oldstore = AppDelegate.sharedAppDelegate().persistentStoreCoordinator!.persistentStores.last as! NSPersistentStore
        
        AppDelegate.sharedAppDelegate().persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: CoreDataHelper2.coreDataGroupURL(), options: options, error: &error)
        
        if error != nil {
            NSLog("Failed to migrate iCloud to local store: %@", error!)
            return false
        }
        
        self.exit()
        return true
    }
    
    func waitForiCloudResponse () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cloudDidRespond", name: FBConstants.kUBIQUITYCHANGED, object: AppDelegate.sharedAppDelegate())
        showActivityIndicatorOnView(self.tabBarController!.view.superview!)
        UIApplication.sharedApplication().keyWindow?.userInteractionEnabled = false
    }
    
    func cloudDidRespond (sender: AnyObject?) {
        NSLog("Got response from iCloud")
        activityIndicatorView.stopAnimating()
        UIApplication.sharedApplication().keyWindow?.userInteractionEnabled = true
        activityIndicatorView = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.exit()
    }
    
    func showActivityIndicatorOnView (aView: UIView) -> UIActivityIndicatorView {
        
        let viewSize = aView.bounds.size
        
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        }
        activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.alpha = 0.7
        activityIndicatorView.backgroundColor = FBConstants.kCOLOR_GRAY_t
        activityIndicatorView.layer.cornerRadius = 10.0
        activityIndicatorView.center = CGPointMake(viewSize.width/2.0, viewSize.height/2.0)
        
        aView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.migrateLocalToiCloudWithRecovery(buttonIndex == 0)
    }
}