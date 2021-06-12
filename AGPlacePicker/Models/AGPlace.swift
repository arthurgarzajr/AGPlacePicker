//
//  AGPlace.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import Foundation

struct AGPlace: Codable, Identifiable {
    var id: String { place_id }
    var business_status: String?
    var geometry: AGPlaceGeometry
    var name: String
    var place_id: String
}
