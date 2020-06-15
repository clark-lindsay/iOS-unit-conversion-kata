//
//  ContentView.swift
//  Unit Converter
//
//  Created by Clark Lindsay on 6/15/20.
//  Copyright © 2020 Clark Lindsay. All rights reserved.
//

import SwiftUI

enum MetricLengths: String, CaseIterable {
    case centimeters, meters, kilometers
}

enum ImperialLengths: String, CaseIterable {
    case inches, feet, miles
}

enum MeasurementSystem: String, CaseIterable {
    case metric, imperial
}

struct ContentView: View {
    @State private var measurement: String = ""
    private var convertedMeasurement: String {
        let failureText = "Error with initial measurement"
        return convertMeasurement(ofValue: measurement, from: unitToConvertFrom, to: unitToConvertTo) ?? failureText
    }
    @State private var convertFromUnitSystem: MeasurementSystem = .metric
    @State private var unitToConvertFrom: MetricLengths = .meters
    @State private var unitToConvertTo: ImperialLengths = .feet

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Measurement in \(unitToConvertFrom.rawValue)", text: $measurement)
                      
                    Section(header: Text("Unit to convert from:")) {
                        Picker("with unit:", selection: $unitToConvertFrom) { ForEach(MetricLengths.allCases, id: \.self) { unit in
                            Text("\(unit.rawValue)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section {
                    Section(header: Text("Unit to convert to:")) {
                        Picker("Convert to:", selection: $unitToConvertTo) { ForEach(ImperialLengths.allCases, id: \.self) { unit in
                            Text("\(unit.rawValue)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section(header: Text("Result:")) {
                    Text("\(convertedMeasurement)")
                }
            }
            .navigationBarTitle("Let's Convert!")
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}

func convertMeasurement(ofValue metricValue: String, from metricUnit: MetricLengths, to imperialUnit: ImperialLengths) -> String? {
    guard let metricValue = Double(metricValue) else { return nil }
    let decimalFormatter = NumberFormatter()
    decimalFormatter.numberStyle = .decimal
    decimalFormatter.maximumFractionDigits = 3
    decimalFormatter.minimumFractionDigits = 1
    var conversionRateToInches: Double = 1
    switch metricUnit {
    case .centimeters:
        conversionRateToInches /= 2.54
    case .meters:
        conversionRateToInches *= 39.37
    case .kilometers:
        conversionRateToInches *= 39370
    }
    var conversionRateToFinalUnit: Double = 1
    switch imperialUnit {
    case .inches:
        conversionRateToFinalUnit *= 1
    case .feet:
        conversionRateToFinalUnit /= 12
    case .miles:
        conversionRateToFinalUnit /= 63360
    }
    if let result = decimalFormatter.string(from: metricValue * conversionRateToInches * conversionRateToFinalUnit as NSNumber) {
        return "\(result) \(imperialUnit.rawValue)"
    }
    return nil
}
