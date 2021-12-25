//
//  AQMListViewModel.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMListViewModel class does is :**
//1. AQMDataProvider provides response data
//2. Parse response data
//3. Inform items binding implementer for data updation

import Foundation
import RxSwift
import RxCocoa

class AQMListViewModel {
    //All city data
    var prevItems: [AQMCityDataModel] = [AQMCityDataModel]()
    //Binding publish subject for recieving updates
    var items = PublishSubject<[AQMCityDataModel]>()
    //AQMDataProvider instance
    var provider: AQMDataProvider?

    //Intialize with data provider
    init(dataProvider: AQMDataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }

    //Subscribe to recieve city's updated history data
    func subscribe() {
        provider?.subscribe()
    }

    //Unsubscribe to stop recieving city's updated history data
    func unsubscribe() {
        provider?.unsubscribe()
    }
}

extension AQMListViewModel: AQMDataProviderDelegate {

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

        if prevItems.count == 0 {
            for record in resArray {
                let model = AQMCityDataModel(city: record.city)
                model.history.append(AQMModel(value: record.aqi, date: Date()))
                prevItems.append(model)
            }
        } else {
            for record in resArray {
                let matchedResults = prevItems.filter { $0.city == record.city }
                if let matchedRes = matchedResults.first {
                    matchedRes.history.append(AQMModel(value: record.aqi, date: Date()))
                } else {
                    let model = AQMCityDataModel(city: record.city)
                    model.history.append(AQMModel(value: record.aqi, date: Date()))
                    prevItems.append(model)
                }
            }
        }
        items.onNext(prevItems)
    }

    //Helper to didReceive() method for error handling
    func handleError(error: Error?) {
        if let error = error {
            items.onError(error)
        }
    }
}

