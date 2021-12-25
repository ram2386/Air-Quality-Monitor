//
//  AQMFakeDataProvider.swift
//  AirQualityMonitoringTests
//
//  Created by Ramkrishna Sharma on 25/12/21.
//

import XCTest
import RxSwift

@testable import AirQualityMonitoring

typealias AQMDataProviderResponse = Result<[AQMResponseData], Error>

class AQMFakeDataProvider: AQMDataProvider {
    private var fakeResponse: AQMDataProviderResponse
    var item = PublishSubject<AQMCityDataModel>()

    init(fakeResponse: AQMDataProviderResponse) {
        self.fakeResponse = fakeResponse
    }

    override func subscribe() {
        notifyFakeResponse()
    }

    private func notifyFakeResponse() {
        switch self.fakeResponse {
        case .success(let res):
            self.delegate?.didReceive(response: .success(res))
        case .failure(let error):
            self.delegate?.didReceive(response: .failure(error))
        }
    }
}
