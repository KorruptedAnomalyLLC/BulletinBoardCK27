//
//  MessageListViewController.swift
//  BulletinBoardCK27
//
//  Created by Austin West on 7/8/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: MessageController.shared.messagesWereUpdatedNotification, object: nil)
        
        MessageController.shared.fetchMessageRecords()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: MessageController.shared.messagesWereUpdatedNotification, object: nil)
    }
    
    @objc func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let messageText = textField.text, messageText != "" else { return }
        textField.text = ""
        MessageController.shared.saveMessageRecord(messageText)
    }
    
}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.shared.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        let message = MessageController.shared.messages[indexPath.row]
        
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timestamp.formatDate()
        
        return cell
    }
}
