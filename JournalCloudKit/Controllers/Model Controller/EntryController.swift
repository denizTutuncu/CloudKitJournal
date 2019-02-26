//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Deniz Tutuncu on 2/25/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    //Source of Truth
    var entries: [Entry] = []
    
    //MARK: - Public Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - Crud Func
    func save(entry: Entry, completion: @escaping (Bool) -> Void) {
        
        let entryAsRecord = CKRecord(entry: entry)
        
        privateDB.save(entryAsRecord) { (record, error) in
            
            if let error = error {
                print("Error saving record to PrivateDB: \(error.localizedDescription)")
                completion(false)
                return
            }
            if let record = record, let returnEntry = Entry(ckRecord: record) {
                self.entries.append(returnEntry)
                completion(true)
            }
        }
    }
    
    func addEntryWith(title: String, bodyText: String, completion: @escaping (Bool) -> Void) {
        let newEntry = Entry(title: title, bodyText: bodyText)
        
        save(entry: newEntry) { (success) in
            if success {
                self.entries.append(newEntry)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.entryKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching entries from CloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else { completion(false); return }
            
            let entries = records.compactMap({ Entry(ckRecord: $0 )})
            self.entries = entries
            completion(true)
        }
    }
    
    
}
