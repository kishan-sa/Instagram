//
//  AddDataController.swift
//  Instagram
//
//  Created by  Kishan Vekariya on 01/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import SVProgressHUD

class AddDataController: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var db : Firestore!
    let defaults = UserDefaults.standard
    var imagepicker = UIImagePickerController()
    var imageid = ""
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textview.layer.borderWidth = 0.5
        textview.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }
    func uploadimage(){
        // Points to the root reference
       
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.green)     //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.gray)      //HUD Color
        let storageRef = Storage.storage().reference(withPath: "images/\(imageid).jpg")
    
        
        guard let imagedata = imageview.image?.jpegData(compressionQuality: 0.75) else{ return }
        let uploaddata = StorageMetadata.init()
        uploaddata.contentType = "image/jpeg"
        storageRef.putData(imagedata, metadata: uploaddata, completion: { (downloaddata, error) in
            if let error = error {
                print("error:\(error)")
                return
            }
            //print("uploaded : \(String(describing: downloaddata))")
            SVProgressHUD.dismiss()
        })
        
    }
    
    @IBAction func addimagepressed(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            
            imagepicker.sourceType = .photoLibrary
            imagepicker.delegate = self
            imagepicker.mediaTypes = ["public.image", "public.movie"]
            
            
            present(imagepicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func addvideopressed(_ sender: Any) {
        
        
        
        
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            imageview.image = selectedImage!
            //self.imageview.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            imageview.image = selectedImage!
            print(selectedImage!)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func sharebuttonpressed(_ sender: Any) {
        
        var postString = textview.text!
        
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("postss").addDocument(data: ["postdata": "\(postString)"]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.textview.text = ""
                postString = ""
                
            }
        }

        imageid = (ref?.documentID)!
        uploadimage()
        imageview.image = nil
        imageid = ""
    }
    
}

