//
//  UserViewCell.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

class UserViewCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    func setDataUserCell(user: User){
        
        self.imgView.image = UIImage(named: "user_image_blank")
        
        self.imgView.layer.cornerRadius = self.imgView.frame.width / 2
        self.imgView.layer.masksToBounds = true
        
        self.nameLbl.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
        self.emailLbl.text = "\(user.email.lowercased())"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.timeLbl.text = "\(formatter.string(from:user.registered.date))"
        
        
        ImageService.sharedInstance.requestImage(url: user.picture.thumbnail){ (image) in
            DispatchQueue.main.async {
                self.imgView.image = image
            }
        }
    }
}

