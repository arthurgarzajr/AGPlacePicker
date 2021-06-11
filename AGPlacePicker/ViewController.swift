//
//  ViewController.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import UIKit
import SwiftUI
import GoogleMaps
class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlacesListView()
    }

    @IBAction func searchButtonTapped(_ sender: Any) {

    }
    
    private func showPlacesListView() {
        let hostingViewController = UIHostingController(rootView: PlacesListView())
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
}

