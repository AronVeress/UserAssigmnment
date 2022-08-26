//
//  ViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users: Array<User> = Array<User>()
    var itemPerPage = APIController()
    

    @IBOutlet var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            userTableView.dataSource = self
            userTableView.delegate = self
            requestUsers()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCellViewController
        cell.setData(user: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == self.users.count - 3) {
            requestUsers()
        }
    }
    
    func requestUsers() {
        if(!APIController.sharedInstance.isOnRequest()) {
            APIController.sharedInstance.downloadJson(item: itemPerPage.call, onSuccess: successfullyRetrievedUserList(retrievedUsers:), onFail: failedToRetrieveUserList(error:))
        }
    }
    
    func successfullyRetrievedUserList(retrievedUsers: Array<User>){
        users.append(contentsOf: retrievedUsers)
        userTableView.reloadData()
        userTableView.isHidden = false
    }
    
    func failedToRetrieveUserList(error: Error){
        print(error.localizedDescription)
        userTableView.isHidden = true
    }
}
