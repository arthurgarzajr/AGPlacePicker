//
//  AGPlacePickerAPI.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import Foundation
import CoreLocation

protocol AGPlacePickerAPIProtocol {
    func fetchPlaces(near location: CLLocationCoordinate2D, radius: Int) async throws -> [AGPlace]
}

enum AGPlacePickerError: Error {
    case badURL
    case invalidServerResponse
    case nilData
    case decodeError
}

class AGPlacePickerAPI: AGPlacePickerAPIProtocol {
    
    func fetchPlaces(near location: CLLocationCoordinate2D, radius: Int) async throws -> [AGPlace] {
        let urlComponents = getUrlComponents(near: location, radius: radius)

        guard let url = urlComponents.url else {
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
    
    private func getUrlComponents(near location: CLLocationCoordinate2D, radius: Int) -> URLComponents {
        var components = URLComponents()
            components.scheme = "https"
            components.host = "maps.googleapis.com"
            components.path = "/maps/api/place/nearbysearch/json"
            components.queryItems = [
                URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
                URLQueryItem(name: "radius", value: String(radius)),
                URLQueryItem(name: "key", value: googleAPIKey)
            ]
        print(components.url?.absoluteString)
        return components
    }
}
