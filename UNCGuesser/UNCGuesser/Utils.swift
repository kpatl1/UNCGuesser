//
//  Utils.swift
//  UNCGuesser
//
//  Created by Josh Myatt on 11/29/22.
//

import Foundation
import MapKit
import SwiftUI

public struct Utils {
    @State var locations = ["Abernethy Annex", "Art Studio Building", "Arts and Sciences Foundation", "Friday Center", "FedEx Global Education Center", "Davis Library", "Health Sciences Library", "House Undergraduate Library"].shuffled()

    var locationsDict = ["Abernethy Annex": [35.897587, -79.057671], "Art Studio Building": [35.931885, -79.058293], "Arts and Sciences Foundation": [35.918081, -79.046419], "Friday Center": [35.897316, -79.012161], "FedEx Global Education Center": [35.907817, -79.054528], "Davis Library": [35.910959, -79.047907], "Health Sciences Library": [35.908366, -79.052776], "House Undergraduate Library": [35.909768, -79.049045]]

    var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.9, longitude: -79.05), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
}
