//
//  SwiftyWeatherApp.swift
//  SwiftyWeather
//
//  Created by Oscar De Villiers on 2026/06/03.
//

import SwiftUI
import SwiftData

@main
struct SwiftyWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .modelContainer(for: Preference.self)
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
