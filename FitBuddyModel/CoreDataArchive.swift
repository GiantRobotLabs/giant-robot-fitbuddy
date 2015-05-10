//
//  CoreDataArchive.swift
//  FitBuddy
//
//  Created by john.neyer on 5/10/15.
//  Copyright (c) 2015 jneyer.com. All rights reserved.
//

import Foundation
import FitBuddyCommon

public class CoreDataArchive : NSObject {
    
    lazy public var exportFileName : String = {
        
        let filename = FBConstants.kEXPORTNAME.stringByAppendingString("-").stringByAppendingString(self.getTimestamp()).stringByAppendingString(FBConstants.kEXPORTEXT)
        return filename
        
        }()
    
    public func getTimestamp () -> String {
        return FitBuddyUtils.dateFromNSDate(NSDate(), format: "ddMMyyHHmmss")
    }
    
    public func exportToDisk (force: Bool) -> NSURL? {
        
        let exportPath = CoreDataHelper2.localDocsURL().URLByAppendingPathComponent(self.exportFileName)
        CoreDataHelper2.migrateDataStore(CoreDataConnection.defaultConnection().theLocalStore, sourceStoreType: CoreDataType.GROUP, destSqliteStore: exportPath, destStoreType: CoreDataType.LOCAL, delete: false)
        
        return exportPath;
    }
    
    
}