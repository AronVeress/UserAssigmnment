//
//  UserDetailViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 01/09/2022.
//

import Foundation
import UIKit

class UserDetailViewController: UIViewController, UITextViewDelegate{
    
    var userFromUserDetail: User?
    var userDict = [String:Any]()
     
    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var cellNumberLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var exactLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textField: UITextView!
    @IBOutlet var activateTextField: UISwitch!
    @IBAction func switchChanged(_ sender: Any) {
        if activateTextField.isOn {
            textField.isHidden = true
            writeToUserDefaults()
        } else {
            textField.isHidden = false
            writeToUserDefaults()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.delegate = self
        hideKeyboardWhenTappedAround()
        readFromUserDefaults()
        
        
        //Image
        ImageService.sharedInstance.requestImage(url: userFromUserDetail!.picture.large ){ (image) in
            DispatchQueue.main.async {
                self.userProfilePic.image = image
            }
        }
        userProfilePic.layer.masksToBounds = true
        userProfilePic.layer.cornerRadius = self.userProfilePic.frame.width / 2.0
        
        //Name Label
        userNameLabel.text = "\(userFromUserDetail!.name.first.capitalized) \(userFromUserDetail!.name.last.capitalized)"
        
        //gender Label
        genderLabel.text = userFromUserDetail?.gender.capitalized
        
        //birthday Label
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayLabel.text = "\(formatter.string(from:userFromUserDetail!.registered.date))"
        
        
        //age label
        ageLabel.text = "\(userFromUserDetail!.dob.age)"
        
        //cell number label
        cellNumberLabel.text = userFromUserDetail?.cell
        
        //phone number label
        phoneNumberLabel.text = userFromUserDetail?.phone
        
        //Country label
        regionLabel.text = String("\(userFromUserDetail!.location.country), \(userFromUserDetail!.location.city)")
        
        //City label
        exactLabel.text = "\(userFromUserDetail!.location.street.name), \(userFromUserDetail!.location.street.number) "
        
        //keyboard management
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(writeToUserDefaults), name: UIApplication.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    @objc func writeToUserDefaults() {
        let userDefaults = UserDefaults.standard
        guard let userKey = userFromUserDetail?.login.uuid else {return}

        
        userDict["userTextInput"] = textField.text
        userDict["userBoolInput"] = activateTextField.isOn
        userDefaults.set(userDict, forKey: userKey)

    }
    
    func readFromUserDefaults() {
        guard let userKey = userFromUserDetail?.login.uuid else {return}
        let userDefaults = UserDefaults.standard
        let userData: [String:Any] = userDefaults.object(forKey: userKey) as? [String:Any] ?? [:]
        textField.text = userData["userTextInput"] as? String
        activateTextField.isOn = userData["userBoolInput"] as! Bool
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        writeToUserDefaults()
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.frame.origin.y = 0
        view.endEditing(true)
    }
}
