//
//  TableViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users: Array<User> = Array<User>()
    var apiService = APIService()
    
    
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
    
    func requestUsers() {
        APIService.sharedInstance.fetchUsers(item: apiService.usersCount, onSuccess: successfullyRetrievedUserList(retrievedUsers:), onFail: failedToRetrieveUserList(error:))
    }
    
    func successfullyRetrievedUserList(retrievedUsers: Array<User>){
        users.append(contentsOf: retrievedUsers)
        DispatchQueue.main.async {
            self.userTableView.reloadData()
        }
    }
    
    func failedToRetrieveUserList(error: Error){
        print(error.localizedDescription)
    }
}
