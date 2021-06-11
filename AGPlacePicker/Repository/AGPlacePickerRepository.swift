//
//  AGPlacePickerRepository.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import Foundation
import GooglePlaces
protocol AGPlacePickerRepositoryProtocol {
    func fetchPlaces() async throws -> Void
}

class AGPlacePickerRepository: ObservableObject, AGPlacePickerRepositoryProtocol {
    
    var service: AGPlacePickerAPIProtocol
    
    @Published var places: [AGPlace] = []
    
    init(service: AGPlacePickerAPIProtocol) {
        self.service = service
    }
    
    func fetchPlaces() async throws {
        let places = try await service.fetchPlaces()
        self.places = places
    }
}
