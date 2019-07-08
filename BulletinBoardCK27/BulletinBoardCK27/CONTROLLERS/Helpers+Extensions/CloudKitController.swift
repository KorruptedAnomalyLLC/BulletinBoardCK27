//
//  CloudKitController.swift
//  BulletinBoardCK27
//
//  Created by Austin West on 7/8/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    // Singleton
    static let shared = CloudKitController()
    
    // Database instances
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    // Create
    func saveRecordToCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (Bool)-> Void) {
        // Save the record passed in, complete with an optional error
        database.save(record) { (_, error) in
            // Error handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)  /n---n/n \(error)")
                completion(false)
            }
            print(#function)
            completion(true)
        }
    }
    
    // Read
    func fetchRecordsOf(type: String, database: CKDatabase, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        // Conditions of query, conditions to be return all found values
        let predicate = NSPredicate(value: true)
        // query       Defines the record type we want to find, applies our predicate conditions
        let query = CKQuery(recordType: type, predicate: predicate)
        // Perform query, complete with our oprtional records and optional error
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)  /n---n/n \(error)")
                completion(records, error)
            }
            if let records = records {
                completion(records, nil)
            }
        }
    }
}
