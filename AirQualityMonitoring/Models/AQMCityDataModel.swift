//
//  AQMCityDataModel.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMResponseData model class does is :**
//1. Used when AQMResponseData model  data is coverted into AQMCityDataModel data

import Foundation
import UIKit

class AQMModel {
    //Air quality index value
    var value: Float = 0.0
    //Data on which date recieved
    var date: Date = Date()
    //Intialize method
    init(value: Float, date: Date) {
        //2 decimal point representation
        if let twoPointValue: Float = Float(String(format: "%.2f", value)) {
            self.value = twoPointValue
        }
        self.date = date
    }
}

protocol AQMCityDataModelProtocol {
    //City name
    var city: String { get set }
    //All city's history data
    var history: [AQMModel] { get set }
}

class AQMCityDataModel: AQMCityDataModelProtocol {
    //City name
    var city: String
    //All city's history data
    var history: [AQMModel] = [AQMModel]()
    //Intialize method
    init(city: String) {
        self.city = city
    }
}

struct AQMQuideModel {
    //Index
    let index: String
    //Category
    let category: AQMIndexClassification
    //Color
    let color: UIColor
}
