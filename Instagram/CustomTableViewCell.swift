//
//  CustomTableViewCell.swift
//  Instagram
//
//  Created by  Kishan Vekariya on 01/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

protocol update {
    func updatepost(newpost : String , index : Int)
}

protocol delete {
    func deletepost(index : Int)
}

protocol image {
    func notify(index : Int)
}

class CustomTableViewCell: UITableViewCell {

    var index = 0
    public var updatedelegate : update?
    public var deletedelegate : delete?
    public var imagedelegate : image?
    
    
    @IBOutlet weak var likeimage: UIButton!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var postimageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func updatebutonpressed(_ sender: Any) {
        
       
        updatedelegate?.updatepost(newpost: textview.text!, index: index)
        
    }
    

    @IBAction func deletebuttonpressed(_ sender: Any) {
        
        deletedelegate?.deletepost(index: index)
        
    }
    
    @IBAction func likepressed(_ sender: Any) {
        
        if (likeimage.currentImage?.isEqual(UIImage(named: "notlike")))!{
            likeimage.setImage(UIImage(named: "Like"), for: .normal)
        }else{
            likeimage.setImage(UIImage(named: "notlike"), for: .normal)
        }
        
    }
    
    @IBAction func tochedOnImage(_ sender: Any) {
        
        imagedelegate?.notify(index: index)
        
    }
}
