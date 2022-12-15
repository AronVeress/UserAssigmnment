//
//  MapViewController.swift
//  UserJSON1
//
//  Created by Aron Veress on 31/10/2022.
//

import UIKit
import MapKit

class MapViewController:UIViewController, MKMapViewDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var activitySpinner: UIActivityIndicatorView!
    
    private var userMap: Array<User> = Array<User>()
    private var apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.delegate = self
        showSpinner()
        requestUsers()
        
    }
    
    private func placeAnnotations(users: [User]) {
        for user in users {
            guard let userLongitude = Double(user.location.coordinates.longitude) else {return}
            guard let userLatitude =  Double(user.location.coordinates.latitude) else {return}
            let location = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
            let userTitle = user.name.first + " " + user.name.last
            let userEmail = user.email
            let userID = user.login.uuid
            
            let annotation = MyAnnotation(coordinate: location,title:userTitle,subtitle:userEmail, picture: user.picture.thumbnail, id: userID)
            annotation.title = userTitle
            annotation.subtitle = userEmail
            
            mapView.addAnnotation(annotation)
        }
    }
    
    private func updateUserImageOnMap(){
        
    }
    private func requestUsers() {
        APIService.sharedInstance.fetchUsers(item: apiService.usersCount, onSuccess: successfullyRetrievedUserList(retrievedUsers:), onFail: failedToRetrieveUserList(error:))
    }
    
    private func successfullyRetrievedUserList(retrievedUsers: Array<User>){
        userMap.append(contentsOf: retrievedUsers)
        DispatchQueue.main.async { [self] in
            self.placeAnnotations(users: userMap)
            self.hideSpinner()
        }
    }
    
    private func failedToRetrieveUserList(error: Error){
        print(error.localizedDescription)
    }
    
    private func showSpinner(){
        activitySpinner.startAnimating()
        mapView.isHidden = true
    }
    
    private func hideSpinner(){
        activitySpinner.stopAnimating()
        activitySpinner.hidesWhenStopped = true
        mapView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Location"){
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            annotationView.pinTintColor = UIColor(red: 0, green: 0,
                                           blue: 0, alpha: 1)
            
            let button = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = button
        
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let annotation = view.annotation
        let index = (mapView.annotations as NSArray).index(of: annotation!)
        print ("Annotation Index = \(index), \(userMap[index].name.first)")
        
        let nameForDetail = userMap[index].name.first

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailVC = storyboard.instantiateViewController(withIdentifier: "userDetail") as! UserDetailViewController

    detailVC.userFromUserDetail = userMap[index]

    self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
