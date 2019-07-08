//
//  MessageController.swift
//  BulletinBoardCK27
//
//  Created by Austin West on 7/8/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import Foundation

class MessageController {
    
    // Singleton
    static let shared = MessageController()
    
    // Source of Truth
    var messages: [Message] = []
    
    
    // Mark: = CRUD
    // Create
    func saveMessageRecord(_ text: String) {
        // init a message
        let messageToSave = Message(text: text)
        let database = CloudKitController.shared.publicDatabase
        
        CloudKitController.shared.saveRecordToCloudKit(record: messageToSave.cloudKitRecord, database: database) { (success) in
            if success {
                print("We did it!")
                self.messages.append(messageToSave)
            }
        }
        
        //Read
        func fetchMessageRecords() {
            let database = CloudKitController.shared.publicDatabase
            CloudKitController.shared.fetchRecordsOf(type: Message.typeKey, database: database) {
                ( records, error) in
                // handle error
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                }
                // verify records exist
                guard let foundRecords = records else { return }
                
                // Iterates through foundRecords, init Messages from the values that can init a message, creating a new array from the successes
                let messages = foundRecords.compactMap( {Message(record: $0)} )
                
                //  Set source of truth
                self.messages = messages
                
            }
        }
    }
}
