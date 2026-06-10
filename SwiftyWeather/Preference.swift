//
//  Preference.swift
//  SwiftyWeather
//
//  Created by Oscar De Villiers on 2026/06/07.
//

import Foundation
import SwiftData

@Model
class Preference {
    
    var locationName: String
    var latString: String
    var longString: String
    var selectedUnit: UnitSystem
    var degreeUnitShowing: Bool
    
    init(locationName: String, latString: String, longString: String, selectedUnit: UnitSystem, degreeUnitShowing: Bool) {
        self.locationName = locationName
        self.latString = latString
        self.longString = longString
        self.selectedUnit = selectedUnit
        self.degreeUnitShowing = degreeUnitShowing
    }
    
    convenience init() {
        self.init(locationName: "Cape Town", latString: "-33.9249", longString: "18.4241", selectedUnit: .metric, degreeUnitShowing: true)
    }
}

extension Preference {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Preference.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(Preference(locationName: "Dublin", latString: "53.338808", longString: "-6.2551", selectedUnit: .metric, degreeUnitShowing: true))
        
        return container
    }
}
