//
//  HomeScreenController.swift
//  Instagram
//
//  Created by  Kishan Vekariya on 01/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import SideMenu
import SVProgressHUD

class HomeScreenController: UIViewController , UITableViewDataSource , UITableViewDelegate ,update , delete , image{
    
    
    

    @IBOutlet weak var logoimage: UIImageView!
    var postss : [Post] = []
    var posts : [String] = []
    var imagesid : [String] = []
    var db : Firestore!
    var index = 0
    var uiimages : UIImage?
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    
    //MARK: - controller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let origImage = UIImage(named: "logo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            
        //logoimage.setImage(tintedImage, for: .normal)
        logoimage.image = tintedImage
        logoimage.tintColor = .black
        
        db = Firestore.firestore()
        
        view1.layer.cornerRadius = 30
        view2.layer.cornerRadius = 30
        view3.layer.cornerRadius = 30
        view4.layer.cornerRadius = 30
        tableview.delegate = self
        tableview.dataSource = self
        postss = []
        read()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //tableview.reloadData()
        postss = []
        read()
        
//        tableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    
    func  read() {
        
        SVProgressHUD.show()
        db = Firestore.firestore()
        postss = []
        
        db.collection("postss").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let newpost = Post()
                    print("\(document.documentID) => \(document.data())")
                    self.posts.append(document.documentID)
                    newpost.post = "\(document.data()["postdata"] as! String)"
                    newpost.imagename = "\(document.documentID)"
                    
                    // Create a reference to the file you want to download
                    let storageRef = Storage.storage().reference(withPath: "images/\(document.documentID).jpg")
                    
                    // Download in memory with a maximum allowed size of 4MB (4 * 1024 * 1024 bytes)
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("error downloading image:\(error)")
                            
                        } else {
                            // Data for "images/island.jpg" is returned
                            newpost.image = UIImage(data: data!)
                            self.postss.append(newpost)
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                            }
                        }
                    }
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    func updatepost(newpost: String, index: Int) {
        
        
            db = Firestore.firestore()
            db.collection("postss").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("post:")
                    print(querySnapshot?.documents[index].data()["postdata"] as! String)
                    
                    let docid = querySnapshot?.documents[index].documentID
                    print("inside uodate:::::\(docid!)")
                    self.db.collection("postss").document("\(docid!)").updateData([
                        "postdata" : "\(newpost)"
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            
                        } else {
                            print("Document successfully updated")
                            
                        }
                    }
                    
                    self.read()
                }
                
        }
        
       
    }
    
    
    func deletepost(index: Int) {
        
        db = Firestore.firestore()
        
        
        
        db.collection("postss").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("post:")
                print(querySnapshot?.documents[index].data()["postdata"] as! String)
                
                let docid = querySnapshot?.documents[index].documentID
                print("inside delete:::::\(docid!)")
                self.db.collection("postss").document("\(docid!)").delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                self.read()
            }
            
        }
 
        
    }
    
    func notify(index: Int) {
        
        uiimages = postss[index].image!
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "image") as! ImageViewController
        nextViewController.image = uiimages!
        navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    

    //MARK: - table methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postss.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusetablecell", for: indexPath) as! CustomTableViewCell
        cell.updatedelegate = self
        cell.deletedelegate = self
        cell.imagedelegate = self
        let post = postss[indexPath.row]
        cell.textview.text = post.post
        cell.index = indexPath.row
        
        cell.postimageview.image = post.image
        
        //cell.postimageview.image = images[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightOfRow = self.calculateHeight(inString: postss[indexPath.row].post)
        return (heightOfRow + 230)
    }
    
    //custom function for calculate dynamic height
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 370, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
}
