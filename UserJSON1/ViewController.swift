//
//  ViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    let url = URL(string: "https://randomuser.me/api/?results=100&seed=abc")
    var users = [User]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
    }
    
    func downloadJson() {
        guard let downloadURL = url else {return}
        
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error in downloading data")
                return
            }
            print("Data downloaded!")
            do{
                let downloadedUsers = try JSONDecoder().decode(Users.self, from: data)
                self.users = downloadedUsers.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error in decoding downloaded data")
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {
               return UITableViewCell()
           }
        cell.nameLbl.text = users[indexPath.row].name.first + " " + users[indexPath.row].name.last
        cell.emailLbl.text = users[indexPath.row].email
        
            if let imageURL = URL(string: users[indexPath.row].picture.thumbnail) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                
                            cell.imgView.image = image
                        }
                    }
                }
            }
        
         //time stamp
        let formatter: NumberFormatter = {
            let temp = NumberFormatter()
            temp.minimumIntegerDigits = 2
            return temp
        } ()
        let minutes = formatter.string(from: NSNumber(value: Int.random(in: 1...59)))
        let hour = Int.random(in: 1...24)
        let timeStamp: String = ("\(hour) : \(minutes!)")
        
        cell.timeLbl.text = timeStamp
        return cell
        }
}
