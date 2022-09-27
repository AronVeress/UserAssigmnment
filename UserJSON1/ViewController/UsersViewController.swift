//
//  TableViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

private var internetRequest = false

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var userTableView: UITableView!
    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    
    private var users: Array<User> = Array<User>()
    private var apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.dataSource = self
        userTableView.delegate = self
        
        showSpinner()
        requestUsers()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserViewCell
        cell.setDataUserCell(user: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func requestUsers() {
        APIService.sharedInstance.fetchUsers(item: apiService.usersCount, onSuccess: successfullyRetrievedUserList(retrievedUsers:), onFail: failedToRetrieveUserList(error:))
    }
    
    private func successfullyRetrievedUserList(retrievedUsers: Array<User>){
        users.append(contentsOf: retrievedUsers)
        DispatchQueue.main.async {
            self.userTableView.reloadData()
            self.hideSpinner()
        }
    }
    
    private func failedToRetrieveUserList(error: Error){
        print(error.localizedDescription)
        internetRequest = false
    }
    
    private func showSpinner(){
        activitySpinner.startAnimating()
        userTableView.isHidden = true
    }
    
    private func hideSpinner(){
        activitySpinner.stopAnimating()
        activitySpinner.hidesWhenStopped = true
        userTableView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewUserDetail") {
            guard let indexP = userTableView.indexPathForSelectedRow?.row else {return}
            (segue.destination as! UserDetailViewController).userFromUserDetail = users[indexP]
        }
    }
    
}
