//
//  AirQualityMonitoringUITests.swift
//  AirQualityMonitoringUITests
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

import XCTest

class AirQualityMonitoringUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        //Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Table list UI
    func testTableInteraction() {
        //Assert that we are displaying the tableview
        let cityTableView = app.tables["table--cityTableView"]
        XCTAssertTrue(cityTableView.exists, "The city list tableview exists")

        //Get an array of cells
        let tableCells = cityTableView.cells

        if tableCells.count > 0 {
            let count: Int = (tableCells.count - 1)

            let promise = expectation(description: "Wait for table cells")

            for i in stride(from: 0, to: count , by: 1) {
                //Grab the first cell and verify that it exists and tap it
                let tableCell = tableCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                //Does this actually take us to the next screen
                tableCell.tap()

                if i == (count - 1) {
                    promise.fulfill()
                }
                
                let app = XCUIApplication()
                app.navigationBars["Air Quality Index (Cities)"].buttons["infoNavBarRightItem"].tap()
                
                let tablesQuery = app.popovers.tables
                tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["151-200"]/*[[".cells.staticTexts[\"151-200\"]",".staticTexts[\"151-200\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
                tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["51-100"]/*[[".cells.staticTexts[\"51-100\"]",".staticTexts[\"51-100\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
                //Back
                app.navigationBars.buttons.element(boundBy: 0).tap()
            }
            waitForExpectations(timeout: Double(tableCells.count*4), handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")

        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
    }

    //Navigation bar item UI
    func testButtonInteraction() {
        if app != nil {
            let infoButton = app.buttons["infoNavBarRightItem"] //
            if infoButton.exists {
                infoButton.tap()
                XCTAssertTrue(true, "Finished validating info button tap")
            } else {
                XCTAssert(false, "Was not able to find info button")
            }

        } else {
            XCTAssert(false, "Was not able to find app")
        }
    }

    //Launch performance
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
