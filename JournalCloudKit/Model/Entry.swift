//
//  Entry.swift
//  JournalCloudKit
//
//  Created by Deniz Tutuncu on 2/25/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let titleKey = "title"
    static let bodyKey = "body"
   // static let ckRecordIdKey = "ckRecordID"
    static let entryKey = "Entry"
}

class Entry {
    
    let title: String
    let bodyText: String
    let ckRecordID : CKRecord.ID
    
    init(title: String, bodyText: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[Constants.titleKey] as? String, let bodyText = ckRecord[Constants.bodyKey] as? String else { return nil }
        self.init(title: title, bodyText: bodyText, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: Constants.entryKey, recordID: entry.ckRecordID)
        
        self.setValue(entry.title, forKey: Constants.titleKey)
        self.setValue(entry.bodyText, forKey: Constants.bodyKey)
    }
}

