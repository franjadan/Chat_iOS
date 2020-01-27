//
//  ChatsTable.swift
//  Chat
//
//  Created by francisco.adan on 23/01/2020.
//  Copyright © 2020 francisco.adan. All rights reserved.
//

import UIKit

class ChatTable: UITableViewController {
    
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppData.activeChat = ""
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.contacts.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! ChatListCell
        

        cell.chatLabel.text = Array(AppData.contacts.keys) [indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 50)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppData.activeChat = Array(AppData.contacts.keys) [indexPath.row]
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
}
