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
        self.tableView.separatorStyle = .none
        
        self.tableView.estimatedRowHeight = 68.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        self.navigationItem.title = AppData.activeChat
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerForKeyboardNotifications(){

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification){

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            if self.view.frame.origin.y == 0{
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { [weak self] in
                    self?.view.frame.origin.y -= keyboardFrame.cgRectValue.height
                }, completion: nil)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            if self.view.frame.origin.y != 0{
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { [weak self] in
                    self?.view.frame.origin.y += keyboardFrame.cgRectValue.height
                }, completion: nil)
            }
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
        
        if Array(AppData.messages)[index].value[indexPath.row].0 == "Fran" {
            cell.messageLabel.isHidden = true
            cell.myMessageLabel.isHidden = false
            cell.myMessageLabel.text = "\(Array(AppData.messages)[index].value[indexPath.row].1)"
            
        } else {
            cell.messageLabel.isHidden = false
            cell.myMessageLabel.isHidden = true
            cell.messageLabel.text = "\(Array(AppData.messages)[index].value[indexPath.row].1)"
            
        }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 5
        let horizontalPadding: CGFloat = 20
           
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: horizontalPadding/2, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
 */
    

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

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

