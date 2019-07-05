//
//  ImageViewController.swift
//  Instagram
//
//  Created by  Kishan Vekariya on 05/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageview: UIImageView!
    var image : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageview.image = image
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        imageview.addGestureRecognizer(tap)
        let longtap = UILongPressGestureRecognizer(target: self, action: #selector(self.longtap))
        imageview.addGestureRecognizer(longtap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        imageview.addGestureRecognizer(pan)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(self.pinchRecognized(pinch:)))
        imageview.addGestureRecognizer(pinchGesture)
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(recognizer:)))
        imageview.addGestureRecognizer(rotate)
    }
    

    @objc func tap(){
        print("tap")
    }
    @objc func longtap()    {
        print("long")
        
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)        }
    }
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        pinch.view?.transform = (pinch.view?.transform.scaledBy(x: pinch.scale, y: pinch.scale))!
        pinch.scale = 1    }
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
