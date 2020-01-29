//
//  ViewController.swift
//  Chat
//
//  Created by francisco.adan on 22/01/2020.
//  Copyright © 2020 francisco.adan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true 
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = Array(AppData.messages.keys).firstIndex(of: AppData.activeChat)!
        return Array(AppData.messages)[index].value.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCell
        
        let index = Array(AppData.messages.keys).firstIndex(of: AppData.activeChat)!
        cell.messageLabel.text = "\(Array(AppData.messages)[index].value[indexPath.row].1)"
        
        if Array(AppData.messages)[index].value[indexPath.row].0 == "Fran" {
            cell.messageLabel.textAlignment = .right
        } else {
            cell.messageLabel.textAlignment = .left
        }
        
        
        return cell
    }

    @IBAction func sendMessageAction(_ sender: Any) {
        let title = AppData.activeChat
        
        if !messageText.text!.isEmpty {
            let urlString = "https://qastusoft.es/test/estech/\(title)/index.php?token=\(AppData.contacts[title]!)&title=Fran&body=\(messageText.text!.replacingOccurrences(of: " ", with: "%20"))"
            
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    AppData.messages[title]!.append(("Fran",self.messageText.text!))
                   
                    var names:[String] = []
                    var messages:[String] = []
                    
                    for tuple in AppData.messages[title]!{
                        names.append(tuple.0)
                        messages.append(tuple.1)
                    }
                    
                    UserDefaults.standard.set(names, forKey: "Names_\(title)")
                    UserDefaults.standard.set(messages, forKey: "Messages_\(title)")
                    
                    self.tableView.reloadData()
                    self.messageText.text = ""
                }
                
                /*

                guard let data = data else { return }

                do {

                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
                    print(json)
                    
                    
                } catch let jsonError {
                    print(jsonError)
                }
                 */

            }.resume()
        }
    }
}

