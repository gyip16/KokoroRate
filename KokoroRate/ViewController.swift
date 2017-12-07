//
//  ViewController.swift
//  KokoroRate
//
//  Created by Etome on 2017-11-23.
//  Copyright © 2017 Etome. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    static var timer: Timer?
    @IBOutlet weak var HeartRateValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Authorize healthkit
    @IBAction func authorizeTapped(_ sender: Any) {
        HealthKitManager.authorizeHealthKit()
    }
    
    // starts monitoring heart rate (and making fake heart rate if
    // activated)
    @IBAction func startHeartRate(_ sender: Any) {
        ViewController.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBPM), userInfo: nil, repeats: true)
    }
    
    // stops monitoring heart rate
    @IBAction func endHeartRate(_ sender: Any) {
        ViewController.timer?.invalidate()
    }
    
    @objc func updateBPM() {
        /*
         * DO NOT use the saveMockHeartData() function on Physical
         * devices, it will make Heart Data in your Health App as if
         * it was real data and mess it up. It simulates WatchOS sending
         * heart rate samples to the Health app via WatchOS workout applications
         *
         */
        HealthKitManager.saveMockHeartData()
        getAVGHeartRate()
    }
    
    // gets the average heart rate within the last minute given that the heart rate sample data
    // is available inside the health app
    func getAVGHeartRate() {
        
        let typeHeart = HKQuantityType.quantityType(forIdentifier: .heartRate)
        let startDate = Date() - 60 // start date is 60 seconds ago
        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
        
        let squery = HKStatisticsQuery(quantityType: typeHeart!, quantitySamplePredicate: predicate, options: .discreteAverage, completionHandler: {(query: HKStatisticsQuery,result: HKStatistics?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let quantity: HKQuantity? = result?.averageQuantity()
                let beats: Double? = quantity?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                self.HeartRateValue.text! = "\(String(format: "%.f", beats!)) BPM"
            })
        })
        HealthKitManager.healthKitStore.execute(squery)
    }
}

