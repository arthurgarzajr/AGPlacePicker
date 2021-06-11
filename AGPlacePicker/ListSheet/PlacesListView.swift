//
//  PlacesListView.swift
//  AGPlacePicker
//
//  Created by Arthur Garza on 6/11/21.
//

import SwiftUI

struct PlacesListView: View {
    let searchResults = ["Places1", "Places2", "Places3"]
    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { result in
                Text(result)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView()
    }
}
