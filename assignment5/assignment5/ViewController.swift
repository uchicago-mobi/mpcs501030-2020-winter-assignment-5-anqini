//
//  ViewController.swift
//  assignment5
//
//  Created by Whisper on 2020/2/11.
//  Copyright © 2020 Whisper. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var BigLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var annotations: [Place] = []
    var currentIndex: Int = -1
    let dataManager = DataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set MapView Delegate
        mapView.delegate = self
        
        // Set Frame and color
        topView.frame = CGRect(x: view.frame.width / 10, y: view.frame.height / 20, width: view.frame.width * 8 / 10, height: 100)
        topView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        topView.layer.cornerRadius = 5
        
        BigLabel.frame = CGRect(x: topView.frame.width / 10, y: 5, width: topView.frame.width * 6 / 10, height: 50)
        BigLabel.text = "Hello"
        BigLabel.font.withSize(20)
        
        DescriptionLabel.frame = CGRect(x: topView.frame.width / 10, y: 50, width: topView.frame.width * 8 / 10, height: 50)
        DescriptionLabel.text = "Where in the World"
        
        likeButton.frame.origin = CGPoint(x: topView.frame.width * 8 / 10, y: 20)
        
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        
        if view.frame.size.height > view.frame.size.width {
            bottomView.frame = CGRect(x: 0, y: view.frame.height * 9 / 10, width: view.frame.width, height: view.frame.height / 10)
        } else {
            bottomView.frame = CGRect(x: 0, y: view.frame.height * 8 / 10, width: view.frame.width, height: view.frame.height * 2 / 10)
        }
        
        favoriteButton.frame.origin = CGPoint(x: bottomView.frame.width / 2 - favoriteButton.frame.size.width / 2, y: bottomView.frame.height / 2 - favoriteButton.frame.size.height / 2)
        
        // Center to Chicago By default
        self.reCenter()
        
        // load annotation via data Manager
        let plistData = dataManager.loadAnnotationFromPlist()
        
        // add mapView annotations
        for location in plistData.places {
            let annotation = Place()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            annotation.title = location.name
            annotation.subtitle = location.description
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        

        
    }
    
    // hold contraints after rotating
    override func viewWillLayoutSubviews() {
        topView.frame = CGRect(x: view.frame.width / 10, y: view.frame.height / 20, width: view.frame.width * 8 / 10, height: 100)
        BigLabel.frame = CGRect(x: topView.frame.width / 10, y: 5, width: topView.frame.width * 6 / 10, height: 50)
        DescriptionLabel.frame = CGRect(x: topView.frame.width / 10, y: 50, width: topView.frame.width * 8 / 10, height: 50)
        likeButton.frame.origin = CGPoint(x: topView.frame.width * 8 / 10, y: 20)
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if view.frame.size.height > view.frame.size.width {
            bottomView.frame = CGRect(x: 0, y: view.frame.height * 9 / 10, width: view.frame.width, height: view.frame.height / 10)
        } else {
            bottomView.frame = CGRect(x: 0, y: view.frame.height * 8 / 10, width: view.frame.width, height: view.frame.height * 2 / 10)
        }
        
        favoriteButton.frame.origin = CGPoint(x: bottomView.frame.width / 2 - favoriteButton.frame.size.width / 2, y: bottomView.frame.height / 2 - favoriteButton.frame.size.height / 2)
        
    }
    
    // Change Image after Like button is tapped
    @IBAction func likeButtonTapped(_ sender: Any) {
        if dataManager.isFavorite(index: currentIndex) {
            likeButton.setImage(UIImage(systemName: "star"), for: .normal)
            dataManager.deleteFavorite(index: currentIndex)
        } else {
            likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            dataManager.saveFavorites(index: currentIndex)
            // print("button should becomes fill")
        }
    }
    
    // update top view for Favorites Table View Access
    func updateTopView(index: Int) {
        // only accept index not equals to -1
        if index != -1 {
            let annotation = annotations[index]
            BigLabel.text = (annotation.title)!
            DescriptionLabel.text = (annotation.subtitle)!
            if dataManager.isFavorite(index: index) {
                likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        currentIndex = index
    }
    
    // recenter function
    func reCenter(lat: Double = 41.882056, long: Double = -87.627819, latDelta: Double = 0.05, longDelta: Double = 0.05) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta))
        mapView.region = region
    }
    
    // segue prepare
    // pass self as delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination  = segue.destination as! FavoritesViewController
        destination.annotations = annotations
        destination.delegate = self
    }
}

//
extension ViewController: MKMapViewDelegate {
    // when map annotation is tapped
    // update Label
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        BigLabel.text = (view.annotation?.title)!
        DescriptionLabel.text = (view.annotation?.subtitle)!
        currentIndex = annotations.firstIndex(of: view.annotation! as! Place)!
        if dataManager.isFavorite(index: currentIndex) {
            likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
}

extension ViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String) {
        // not in use
    }
    // other functions & properties are define in main ViewController Class
}
