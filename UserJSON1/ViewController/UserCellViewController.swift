//
//  UserCell.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

class UserCellViewController: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func setData(user: User){
        
        self.imgView.image = UIImage(named: "user_image_blank")
        
        self.imgView.layer.cornerRadius = self.imgView.frame.width / 2
        self.imgView.layer.masksToBounds = true
        
        self.nameLbl.text = "\(user.name.first.uppercased()) \(user.name.last.uppercased())"
        self.emailLbl.text = "\(user.email.lowercased())"

        ImageController.sharedInstance.requestImage(url: user.picture.thumbnail){ (image) in 
            self.imgView.image = image
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLbl.text = "\(formatter.string(from:user.registered.date))"
    }
}
    
