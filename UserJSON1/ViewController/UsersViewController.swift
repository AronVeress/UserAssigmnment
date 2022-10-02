//
//  TableViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var userTableView: UITableView!
    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    
    private var users: Array<User> = Array<User>()
    private var filteredUsers: Array<User> = Array<User>()
    private var apiService = APIService()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Search"
        navigationItem.searchController = searchController
        userTableView.dataSource = self
        userTableView.delegate = self
        
        showSpinner()
        requestUsers()
        initSearchController()
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserViewCell
        let user: User
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.setDataUserCell(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String, category: User? = nil) {
        filteredUsers = users.filter{ (user: User ) -> Bool in
            let fullName = user.name.first + user.name.last
            return fullName.lowercased().contains(searchText.lowercased())
        }
        userTableView.reloadData()
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
            if isFiltering {
                (segue.destination as! UserDetailViewController).userFromUserDetail = filteredUsers[indexP]
            } else {
                (segue.destination as! UserDetailViewController).userFromUserDetail = users[indexP]
            }
        }
    }
    
}

extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
