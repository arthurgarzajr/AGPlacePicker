//
//  PlacesListViewModel.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import Foundation
import Combine

class PlacesListViewModel: ObservableObject {
    @Published var places: [AGPlace] = []
    
    var repository: AGPlacePickerRepository
    
    var cancellables = Set<AnyCancellable>()
    
    init(repository: AGPlacePickerRepository) {
        self.repository = repository
        
        repository.$places.sink { places in
            self.places = places
        }.store(in: &cancellables)
    }
    
}
