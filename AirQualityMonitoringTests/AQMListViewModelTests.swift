//
//  AQMListViewModelTests.swift
//  AirQualityMonitoringTests
//
//  Created by Ramkrishna Sharma on 25/12/21.
//

import XCTest
import RxSwift
import RxNimble
import Nimble

@testable import AirQualityMonitoring

// MARK: tests fake data (success)
let fakeResponse: [AQMResponseData] = [AQMResponseData(city: "Delhi", aqi: 200.0)]
let fakeDataProvider: AQMDataProvider = AQMFakeDataProvider(fakeResponse: .success(fakeResponse))

let fakeDataProviderError: AQMDataProvider
    = AQMFakeDataProvider(fakeResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))

class AQMListViewModelTests: XCTestCase {
    let listViewModel: AQMListViewModel = AQMListViewModel(dataProvider: fakeDataProvider)
    let listViewModelError: AQMListViewModel = AQMListViewModel(dataProvider: fakeDataProviderError)

    func testRespnoseDataInformation() {
        listViewModel.subscribe()

        expect(self.listViewModel.prevItems.first?.city) == fakeResponse.first?.city
        expect(self.listViewModel.prevItems.first?.history.last?.value) == fakeResponse.first?.aqi

        listViewModel.unsubscribe()
    }

    func testDataInformationWhenPrevItemsAvailable() {
        let item = AQMCityDataModel(city: "Mumbai")
        item.history = [AQMModel(value: 100, date: Date())]
        listViewModel.prevItems = [item]

        listViewModel.subscribe()

        expect(self.listViewModel.prevItems.first?.city) == "Mumbai"
        expect(self.listViewModel.prevItems.first?.history.last?.value) == 100

        listViewModel.unsubscribe()
    }

    func testErrorResponse() {
        listViewModelError.subscribe()

        let p = self.listViewModelError.prevItems
        expect(p.count) == 0
    }
}
