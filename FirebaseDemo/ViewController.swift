//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Jon Eikholm on 12/03/2018.
//  Copyright © 2018 Jon Eikholm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
// "auth != null"   for later use
class ViewController: UIViewController {

    var ref:DatabaseReference!
    var items:DatabaseQuery?
    let rootName = "todoItems"
    let itemName = "item"
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var testField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() // will give us the root of the DB-tree in Firebase
        // for this particular app.
        items = ref.child(rootName).queryOrdered(byChild: itemName) // create ref. to a query
  
    }
    
    func observeFirebase(){
        // start the query
        items?.observe(.value, with: { (snapshot) in
            self.textView.text = ""
            for child in snapshot.children {
                let childD = child as! DataSnapshot
                let value = childD.value ?? "empty"
                let childData = value as! [String:String]
                let itemData = childData[self.itemName]!
                print(itemData)
                self.textView.text = self.textView.text + itemData + "\n"
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addBtnPressed(_ sender: UIButton) {
        if let text = testField.text {
            let newEntryRef = ref.child(rootName).childByAutoId() // creates new entry with unique id
            newEntryRef.setValue(["id":newEntryRef.key, itemName:text])
            print("added to Firebase: Have Fun! with key \(newEntryRef.key) text: \(text)")
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let user = userNameField.text, let pw = passWordField.text {
            Auth.auth().createUser(withEmail: user, password: pw, completion: { (user, error) in
                if error == nil {
                    print("success in creating user \(user!)")
                }else {
                    print(error ?? "")
                }
            })
        }
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let user = userNameField.text, let pw = passWordField.text {
            Auth.auth().signIn(withEmail: user, password: pw, completion: { (user, error) in
                if error == nil {
                    print("success in logging in \(user!)")
                    self.observeFirebase()
                }else {
                    print(error ?? "")
                }
            })
        }
    }
    
}

