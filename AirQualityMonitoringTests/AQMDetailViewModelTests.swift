//
//  AQMDetailViewModelTests.swift
//  AirQualityMonitoringTests
//
//  Created by Ramkrishna Sharma on 25/12/21.
//

import XCTest
import RxSwift
import RxNimble
import Nimble

@testable import AirQualityMonitoring

//// MARK: tests fake data
let fakeResponseForDetails: [AQMResponseData] = [AQMResponseData(city: "Delhi", aqi: 200.0)]
let fakeDataProviderForDetails: AQMDataProvider = AQMFakeDataProvider(fakeResponse: .success(fakeResponseForDetails))

let fakeDataProviderForDetailsWithError: AQMDataProvider
    = AQMFakeDataProvider(fakeResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))

class AQMDetailViewModelTests: XCTestCase {
    let detailViewModel: AQMDetailViewModel = AQMDetailViewModel(dataProvider: fakeDataProviderForDetails)

    let detailViewModelError: AQMDetailViewModel = AQMDetailViewModel(dataProvider: fakeDataProviderForDetailsWithError)

    func testRespnoseDataInformation() {
        detailViewModel.subscribe(forCity: "Delhi")

        expect(self.detailViewModel.prevItem?.city) == fakeResponse.first?.city
        expect(self.detailViewModel.prevItem?.history.last?.value) == fakeResponse.first?.aqi

        detailViewModel.unsubscribe()
    }

    func testDataInformationWhenPrevItemsAvailable() {
        let item = AQMCityDataModel(city: "Mumbai")
        item.history = [AQMModel(value: 100, date: Date())]
        detailViewModel.prevItem = item

        detailViewModel.subscribe(forCity: "Mumbai")

        expect(self.detailViewModel.prevItem?.city) == "Mumbai"
        expect(self.detailViewModel.prevItem?.history.last?.value) == 100

        detailViewModel.unsubscribe()
    }

    func testErrorResponse() {
        detailViewModelError.subscribe(forCity: "Delhi")

        let p = self.detailViewModelError.prevItem
        expect(p) == nil
    }
}
