//
//  ViewController.swift
//  Instagram
//
//  Created by  Kishan Vekariya on 01/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import Crashlytics

class ViewController: UIViewController ,GIDSignInUIDelegate , GIDSignInDelegate{
    

    @IBOutlet weak var gradiantview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        if Auth.auth().currentUser != nil{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabscreen") as! UITabBarController
            self.navigationController?.pushViewController(nextViewController, animated: false)
            
        }
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.red.cgColor]
        //gradientLayer.colors = [UIColor(red: 78/255, green: 60/355, blue: 172/255, alpha: 1),UIColor(red: 204/255, green: 94/255, blue: 85/255, alpha: 1)]
        //gradientLayer.colors = [UIColor(displayP3Red: 78/255, green: 60/255, blue: 172/255, alpha: 0.5) , UIColor(displayP3Red: 204/255, green: 94/255, blue: 85/255, alpha: 0.5)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        
        gradiantview.layer.addSublayer(gradientLayer)
        
        
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func signButtonPressed(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            print("user sign in")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabscreen") as! UITabBarController
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
    }
    

}

