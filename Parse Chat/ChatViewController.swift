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

    var messages = [PFObject]()
    var timer : Timer!
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        dismiss(animated: true) {
            print("logged out")
        }
    }
    @IBAction func onLogout(_ sender: Any) {
        
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextField!
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageTextView.text ?? ""
        chatMessage["user"] = PFUser.current()
    
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageTextView.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        self.onTimer()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "m") as! ChatCell
        
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        //Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
        
        //}
        
        let chatMessage = messages[indexPath.row]
        //print("the message is: \(chatMessage["text"])")
        if let user = chatMessage["user"] as? PFUser {
            // User found! update username label with username
            //print("the username for this user is: \(user.username)")
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        cell.messageLabel.text = chatMessage["text"] as! String

//        tableView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print(messages.count)
        return messages.count
    }
    
    func onTimer(){
        //print("In timer")
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addAscendingOrder("createdAt")
        
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages{
                self.messages = messages
                self.tableView.reloadData()
            }else{
                print(error?.localizedDescription)
            }
        }
        
       /* query.findObjectsInBackground { (post, error) in
            if error == nil{
                print(post)
                self.messages = post!
            } else {
                print(error)
            }
        }*/
    }

}
