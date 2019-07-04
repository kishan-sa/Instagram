//
//  sidemenuViewController.swift
//  Instagram
//
//  Created by  Kishan Vekariya on 03/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import MessageUI

class SidemenuViewController: UIViewController ,UIActionSheetDelegate {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.isHidden = true
        let user = Auth.auth().currentUser
        namelabel.text = user?.displayName
        let url = user?.photoURL
        
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            imageview.image = image
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        
        
        let canselButton = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(canselButton)
        let emailButton = UIAlertAction(title: "Share via Email", style: .default) { action -> Void in
        
            if !MFMailComposeViewController.canSendMail() {
                let alert = UIAlertController(title: "Alert", message: "Mail services are not available", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("Hello!")
            composeVC.setMessageBody("Hello from California!", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        actionSheetController.addAction(emailButton)
        let MessageButton = UIAlertAction(title: "Share via Messages", style: .default) { action -> Void in
            if !MFMessageComposeViewController.canSendText() {
                let alert = UIAlertController(title: "Alert", message: "SMS services are not available", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self as? MFMessageComposeViewControllerDelegate
            
            // Configure the fields of the interface.
            composeVC.recipients = ["4085551212"]
            composeVC.body = "Hello from Instagram!"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        actionSheetController.addAction(MessageButton)
        let otherButton = UIAlertAction(title: "Share via Others", style: .default) { action -> Void in
            print("Others")
            
            let shareText = "Hello, world!"
            
            
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
                self.present(vc, animated: true, completion: nil)
            
            
        }
        actionSheetController.addAction(otherButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
   
   
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //GIDSignIn.sharedInstance().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            
        }
        
        self.dismiss(animated: false, completion: nil)
        navigationController?.popToRootViewController(animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewcontroller") as? ViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
        //self.tabBarController?.navigationController?.popToRootViewController(animated: true)
        //self.tabBarController?.popoverPresentationController
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
    }
    
}
