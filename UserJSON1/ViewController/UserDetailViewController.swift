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
     
    @IBOutlet private var userProfilePic: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var birthdayLabel: UILabel!
    @IBOutlet private var ageLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var cellNumberLabel: UILabel!
    @IBOutlet private var phoneNumberLabel: UILabel!
    @IBOutlet private var regionLabel: UILabel!
    @IBOutlet private var exactLabel: UILabel!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var textField: UITextView!
    @IBOutlet private var activateTextField: UISwitch!
    @IBAction private func switchChanged(_ sender: Any) {
        if activateTextField.isOn {
            textField.isHidden = activateTextField.isOn
        } else {
            textField.isHidden = activateTextField.isOn
        }
        writeToUserDefaults()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.delegate = self
        hideKeyboardWhenTappedAround()
        readFromUserDefaults()
        writeUserDetails()
        
        //keyboard management
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(writeToUserDefaults), name: UIApplication.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func writeUserDetails(){
        
        guard let userToWrite = userFromUserDetail else {
            return
        }

        
        //Image
        ImageService.sharedInstance.requestImage(url: userToWrite.picture.large ){ (image) in
            DispatchQueue.main.async {
                self.userProfilePic.image = image
            }
        }
        userProfilePic.layer.masksToBounds = true
        userProfilePic.layer.cornerRadius = self.userProfilePic.frame.width / 2.0
        
        //Name Label
        userNameLabel.text = "\(userToWrite.name.first.capitalized) \(userToWrite.name.last.capitalized)"
        
        //gender Label
        genderLabel.text = userToWrite.gender.capitalized
        
        //birthday Label
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayLabel.text = "\(formatter.string(from:userToWrite.registered.date))"
        
        
        //age label
        ageLabel.text = "\(userToWrite.dob.age)"
        
        //cell number label
        cellNumberLabel.text = userToWrite.cell
        
        //phone number label
        phoneNumberLabel.text = userToWrite.phone
        
        //Country label
        regionLabel.text = String("\(userToWrite.location.country), \(userToWrite.location.city)")
        
        //City label
        exactLabel.text = "\(userToWrite.location.street.name), \(userToWrite.location.street.number) "
        
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
        activateTextField.isOn = userData["userBoolInput"] as? Bool ?? false
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
