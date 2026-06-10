//
//  PreferenceView.swift
//  SwiftyWeather
//
//  Created by Oscar De Villiers on 2026/06/07.
//

import SwiftUI
import SwiftData

struct PreferenceView: View {
    @Query var preferences: [Preference]
    @State private var locationName = ""
    @State private var latString = ""
    @State private var longString = ""
    @State private var selectedUnit: UnitSystem = .imperial
    @State private var degreeUnitShowing = true
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var degreeUnit: String {
        if degreeUnitShowing {
            return selectedUnit == .imperial ? "F" : "C"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("location", text: $locationName)
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                    .padding(.bottom)
                
                Group {
                    Text("Latitude:")
                        .bold()
                    
                    TextField("latitude", text: $latString)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Longitude")
                        .bold()
                    
                    TextField("longitude", text: $longString)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom)
                }
                .font(.title2)
                
                
                HStack {
                    Text("Units:")
                        .bold()
                    
                    Spacer()
                    
                    Picker("", selection: $selectedUnit) {
                        ForEach(UnitSystem.allCases, id: \.self) { unit in
                            Text(unit.rawValue.capitalized)
                        }
                    }
                    .padding(.bottom)
                    .disabled(!degreeUnitShowing)
                }
                .font(.title2)
                
                Toggle("Show F/C after temp value", isOn: $degreeUnitShowing)
                    .font(.title2)
                    .bold()
                
                Text("42°\(degreeUnit)")
                    .font(Font.system(size: 150))
                    .fontWeight(.thin)
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .onAppear {
                guard !preferences.isEmpty else { return }
                let preference = preferences.first!
                locationName = preference.locationName
                latString = preference.latString
                longString = preference.longString
                selectedUnit = preference.selectedUnit
                degreeUnitShowing = preference.degreeUnitShowing
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        if !preferences.isEmpty {
                            for preference in preferences {
                                modelContext.delete(preference)
                            }
                        }
                        let preference = Preference(
                            locationName: locationName,
                            latString: latString,
                            longString: longString,
                            selectedUnit: selectedUnit,
                            degreeUnitShowing: degreeUnitShowing
                        )
                        
                        modelContext.insert(preference)
                        guard let _ = try? modelContext.save() else {
                            print("ERROR: Save on PreferenceView failed.")
                            return
                        }
                        dismiss()
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    NavigationStack {
        PreferenceView()
            .modelContainer(Preference.preview)
    }
}
