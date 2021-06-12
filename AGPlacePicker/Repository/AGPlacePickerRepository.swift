//
//  AGPlacePickerRepository.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import Foundation
import GooglePlaces
protocol AGPlacePickerRepositoryProtocol {
    func fetchPlaces(near location: CLLocationCoordinate2D, radius: Int) async throws -> Void
}

class AGPlacePickerRepository: ObservableObject, AGPlacePickerRepositoryProtocol {
    
    var service: AGPlacePickerAPIProtocol
    
    @Published var places: [AGPlace] = []
    
    init(service: AGPlacePickerAPIProtocol) {
        self.service = service
    }
    
    func fetchPlaces(near location: CLLocationCoordinate2D, radius: Int) async throws {
        let places = try await service.fetchPlaces(near: location, radius: radius)
        self.places = places
    }
}
