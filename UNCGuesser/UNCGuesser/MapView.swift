//
//  MapView.swift
//  UNCGuesser
//
//  Created by Josh Myatt on 11/28/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.9, longitude: -79.05), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    @State var mapLocations = [Location]()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: mapLocations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
            .ignoresSafeArea()
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: region.center.latitude, longitude: region.center.longitude)
                        addLocation(newLocation: newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
    }

    func addLocation(newLocation: Location) {
        if mapLocations.count != 0 {
            mapLocations = []
        }
        mapLocations.append(newLocation)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
