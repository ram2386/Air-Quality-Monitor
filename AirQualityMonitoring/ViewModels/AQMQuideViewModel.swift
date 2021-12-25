//
//  AQMQuideViewModel.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 24/12/21.
//

import Foundation
import RxSwift
import RxCocoa

//** AQMQuideViewModel class does is :**
//Prepare the records for guide information about the Air Quality Index

class AQMQuideViewModel {
    //Offset for calculating the range
    let rangeOffset = 50
    //IndexRange Instance
    var indexRange = 50
    //All Air Quality Monitor Index records
    var aqmRecords = [AQMQuideModel]()
    //Binding publish subject for recieving updates
    var items = PublishSubject<[AQMQuideModel]>()

    //Prepare the records for Air Quality Monitor Index guide
    func setupAQMGuide() {
        for (index, element) in AQMIndexClassification.allCases.enumerated() {
            //Fetch the color based on AQMIndexClassification case
            if let backgroundColor = AQMIndexColorClassifier.color(index: element) {
                let firstIndex = index == 0 ? 0 : indexRange-rangeOffset + 1
                aqmRecords.append(AQMQuideModel(index: "\(firstIndex)-\(indexRange)", category: element, color: backgroundColor))
            }
            indexRange += rangeOffset
        }
        aqmRecords.removeLast()
        items.onNext(aqmRecords)
    }
}
