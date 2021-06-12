//
//  ViewController.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import UIKit
import SwiftUI
import GoogleMaps
import Combine
import CoreLocation

class ViewController: UIViewController, ObservableObject {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager: CLLocationManager?
    
    var repository: AGPlacePickerRepository = AGPlacePickerRepository(service: AGPlacePickerAPI())
    
    @Published var places: [AGPlace] = []
    
    var cancellabes = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        subscribeToRepoChanges()
        configureLocationManager()
        fetchPlaces()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showPlacesListView()
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: mapView.bounds.height / 2, right: 0)
        setMapCameraPosition()
    }
    
    private func setMapCameraPosition() {
        if locationAuthorized, let currentLocation = locationManager?.location {
            let target = currentLocation.coordinate
            mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 15)
        }
    }
    
    private func showPlacesListView() {
        let hostingViewController = UIHostingController(rootView: PlacesListView(viewModel: PlacesListViewModel(repository: repository)))
        hostingViewController.modalPresentationStyle = .popover
        hostingViewController.presentationController?.delegate = self
        if let popover = hostingViewController.popoverPresentationController {
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [.medium(), .large()]
            sheet.smallestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(hostingViewController, animated: true)
    }
    
    private func fetchPlaces() {
        if locationAuthorized {
            async {
                do {
                    try await repository.fetchPlaces(near: mapView.camera.target, radius: 500)
                } catch {
                    
                }
            }
        }
    }
    
    private func subscribeToRepoChanges() {
        repository.$places.sink { places in
            self.places = places
            self.plotMarkersOnMap()
        }.store(in: &cancellabes)
    }
    
    private func plotMarkersOnMap() {
        for place in places {
            let marker = GMSMarker()
            let coordinate = CLLocationCoordinate2DMake(place.geometry.location.lat, place.geometry.location.lng)
            marker.position = coordinate
            marker.title = place.name
            marker.map = mapView
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    var locationAuthorized: Bool {
        locationManager?.authorizationStatus == .authorizedAlways || locationManager?.authorizationStatus == .authorizedWhenInUse
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .denied, .restricted:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            fetchPlaces()
        @unknown default:
            break
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        fetchPlaces()
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
}

