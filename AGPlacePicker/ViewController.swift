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

class ViewController: UIViewController, ObservableObject {

    @IBOutlet weak var mapView: GMSMapView!
    
    var repository: AGPlacePickerRepository = AGPlacePickerRepository(service: AGPlacePickerAPI())
    
    @Published var places: [AGPlace] = []
    
    var cancellabes = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlacesListView()
        fetchPlaces()
        subscribeToRepoChanges()
    }

    @IBAction func searchButtonTapped(_ sender: Any) {

    }
    
    private func showPlacesListView() {
        let hostingViewController = UIHostingController(rootView: PlacesListView(viewModel: PlacesListViewModel(repository: repository)))
        hostingViewController.modalPresentationStyle = .popover
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
        async {
            do {
                try await repository.fetchPlaces()
            } catch {

            }
        }
    }
    
    private func subscribeToRepoChanges() {
        repository.$places.sink { places in
            self.places = places
        }.store(in: &cancellabes)
    }
}

