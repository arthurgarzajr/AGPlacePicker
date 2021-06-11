//
//  PlacesListView.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import SwiftUI

struct PlacesListView: View {
    @ObservedObject var viewModel: PlacesListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.places) { place in
                Text(place.name)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView(viewModel: PlacesListViewModel(repository: AGPlacePickerRepository(service: AGPlacePickerAPI())))
    }
}
