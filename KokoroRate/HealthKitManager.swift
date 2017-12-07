//
//  HealthKitManager.swift
//  KokoroRate
//
//  Created by Etome on 2017-11-23.
//  Copyright © 2017 Etome. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {
    

    
    static let healthKitStore = HKHealthStore()
    
    static func authorizeHealthKit() {
        
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        ]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypes,
                                            read: healthKitTypes) { _,_  in }
    }
    
    // Makes Mock Heart Rate data by making a heartrate sample
    // and send it over to Health app via healthkit
    @objc static func saveMockHeartData() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let heartRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"),
                                           doubleValue: Double(arc4random_uniform(80) + 100))
        let heartSample = HKQuantitySample(type: heartRateType,
                                           quantity: heartRateQuantity, start: Date(), end: Date())
        healthKitStore.save(heartSample, withCompletion: { (success, error) -> Void in
            if let error = error {
                print("Error saving heart sample: \(error.localizedDescription)")
            }
        })
    }
    


}
