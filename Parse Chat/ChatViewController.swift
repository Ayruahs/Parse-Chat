//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Shaurya Sinha on 05/02/18.
//  Copyright © 2018 Shaurya Sinha. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextField!
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFUser(className: "Message")
        
        
        chatMessage["text"] = messageTextView.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    var messages = [PFObject]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! ChatCell
        
        let chatMessage = PFUser(className: "Message")
        
        
        chatMessage["text"] = messageTextView.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
        
        if let user = chatMessage["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 5
    }
    
    let time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    
    
    @objc func onTimer(){
        let user = PFUser.current()
        var query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addAscendingOrder("createdAt")
        
        query.findObjectsInBackground { (post, error) in
            if error == nil{
                print(post)
                self.messages = post!
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }

}
