//
//  AQMResponseData.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMResponseData model class does is :**
//1. Used when websocket response is provided

import Foundation

struct AQMResponseData: Codable {
    //City name
    var city: String
    //Air quality index value
    var aqi: Float
    //Intialize method
    init(city: String, aqi: Float) {
        self.city = city
        self.aqi = aqi
    }
}
