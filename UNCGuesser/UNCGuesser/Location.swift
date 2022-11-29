//
//  Location.swift
//  UNCGuesser
//
//  Created by Josh Myatt on 11/28/22.
//

import Foundation
struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}

extension Location {
    static var def = Location(id: UUID(), name: "Default", description: "Default", latitude: 35.8, longitude: -79.01)
}
