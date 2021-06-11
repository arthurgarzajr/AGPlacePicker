//
//  AGPlacePickerAPI.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import Foundation

protocol AGPlacePickerAPIProtocol {
    func fetchPlaces() async throws -> [AGPlace]
}

enum AGPlacePickerError: Error {
    case badURL
    case invalidServerResponse
    case nilData
    case decodeError
}

class AGPlacePickerAPI: AGPlacePickerAPIProtocol {
    
    func fetchPlaces() async throws -> [AGPlace] {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&key=\(googleAPIKey)") else {
            throw AGPlacePickerError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AGPlacePickerError.invalidServerResponse
        }
        
        let decoder = JSONDecoder()
        guard let placesResponse = try? decoder.decode(AGPlacesResponse.self, from: data) else {
            throw AGPlacePickerError.decodeError
        }
        
        return placesResponse.results
    }
}
