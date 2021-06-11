//
//  ViewController.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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


    @IBAction func searchButtonTapped(_ sender: Any) {

    }
}

