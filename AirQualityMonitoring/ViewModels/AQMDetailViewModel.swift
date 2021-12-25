//
//  AQMDetailViewModel.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

import Foundation
import RxSwift
import RxCocoa
import Starscream

//** AQMDetailViewModel class does is :**
//1. AQMDataProvider provides response data
//2. Parse response data
//3. Inform item binding implementer for data updation

class AQMDetailViewModel {
    //City name
    private var city: String = ""
    //Current city selected
    var prevItem: AQMCityDataModel? = nil
    //Binding publish subject for recieving updates
    var item = PublishSubject<AQMCityDataModel>()
    //AQMDataProvider instance
    var provider: AQMDataProvider?
    //Intialize method
    init(dataProvider: AQMDataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    //Subscribe to recieve city's updated history data
    func subscribe(forCity: String) {
        self.city = forCity
        provider?.subscribe()
    }
    //Unsubscribe to stop recieving city's updated history data
    func unsubscribe() {
        provider?.unsubscribe()
    }
}

extension AQMDetailViewModel: AQMDataProviderDelegate {
    //Recieved response from DataProvider
    func didReceive(response: Result<[AQMResponseData], Error>) {
        switch response {

        case .success(let response):
            parseAndNotify(resArray: response)

        case .failure(let error):
            handleError(error: error)
        }
    }

    //Helper to didReceive() method for parsing data
    func parseAndNotify(resArray: [AQMResponseData]) {

        let cityData = resArray.filter { $0.city == city }
        if let data = cityData.first {
            if let prev = prevItem {
                prev.history.append(AQMModel(value: data.aqi, date: Date()))
            } else {
                prevItem = AQMCityDataModel(city: self.city)
                prevItem?.history.append(AQMModel(value: data.aqi, date: Date()))
            }
        } else {
            if let prev = prevItem, let last = prev.history.last {
                prev.history.append(last)
            }
        }

        if let prevRecord = prevItem {
            item.onNext(prevRecord)
        }
    }

    //Helper to didReceive() method for error handling
    func handleError(error: Error?) {
        if let error = error {
            item.onError(error)
        }
    }
}

