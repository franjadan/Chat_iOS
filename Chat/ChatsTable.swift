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
        
        for chats in AppData.messages {
            let chatName = chats.key
            
            if UserDefaults.standard.array(forKey: "Names_\(chatName)") != nil && UserDefaults.standard.array(forKey: "Messages_\(chatName)") != nil {
                
                let names = UserDefaults.standard.array(forKey: "Names_\(chatName)") as! [String]
                let messages = UserDefaults.standard.array(forKey: "Messages_\(chatName)") as! [String]
                
                var chatMessages: [(String, String)] = []
                
                for index in 0..<names.count {
                    chatMessages.append((names[index], messages[index]))
                }
                
                AppData.messages[chatName] = chatMessages
            }
        }
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
        return CGFloat(integerLiteral: 70)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppData.activeChat = Array(AppData.contacts.keys) [indexPath.row]
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let delete = UIContextualAction(style: .destructive, title: "Limpiar") { (_, _, boolValue) in
                boolValue(true)
                
                let alert = UIAlertController(title: "Confirmación", message: "¿Estás seguro de borrar todos los mensajes?", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

                let deleteAction = UIAlertAction(title: "Limpiar", style: .destructive) { _ in
                    AppData.messages[Array(AppData.contacts.keys)[indexPath.row]] = []
                    UserDefaults.standard.removeObject(forKey: "Names_\(Array(AppData.contacts.keys)[indexPath.row])")
                    UserDefaults.standard.removeObject(forKey: "Messages_\(Array(AppData.contacts.keys)[indexPath.row])")
                }

                alert.addAction(cancelAction)
                alert.addAction(deleteAction)

                self.present(alert, animated: true, completion: nil)
            }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
}
