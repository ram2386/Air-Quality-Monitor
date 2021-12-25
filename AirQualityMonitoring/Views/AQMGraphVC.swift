//
//  AQMGraphVC.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMGraphVC view class does is :**
//1. In ListVC screen, when user taps on UITableViewCell then this screen is shown.
//2. Selected city's history data is shown in chart representation.

import UIKit
import RxSwift
import RxCocoa
import Charts

class AQMGraphVC: UIViewController {
    //CityDataModel instance
    var cityModel: AQMCityDataModel = AQMCityDataModel(city: "")

    //DetailViewModel instance
    private var viewModel: AQMDetailViewModel?

    //Thread safe bag that disposes added disposables on `deinit`.
    private var bag = DisposeBag()

    //LineChartView instance
    private let chartView = LineChartView()

    //All data entries for LineChartView
    var dataEntries = [ChartDataEntry]()

    //Determine how many dataEntries show up in the chartView
    var xValue: Double = 20

    //Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = AQMDetailViewModel(dataProvider: AQMDataProvider())

        self.title = cityModel.city

        view.addSubview(chartView)
        chartView.xAxis.axisMinimum = 1
        chartView.noDataText = "No data available"

        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        setupInitialDataEntries()

        setupChartData()

        bindData()
    }

    //Bind CityDataModel's item to get updated data
    func bindData() {
        viewModel?.item.bind { model in
            if let v = model.history.last?.value {
                let roundingValue: Double = Double(round(v * 100) / 100.0)
                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }
        }.disposed(by: bag)
    }

    //Life cycle method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Subscribe
        viewModel?.subscribe(forCity: cityModel.city)
    }

    //Life cycle method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe
        viewModel?.unsubscribe()
    }
}

// Graph UI
extension AQMGraphVC {
    //Set intial entries so blank chart is loaded
    func setupInitialDataEntries() {
        let totaValues = 0..<Int(xValue)
        for _ in totaValues {
            let dataEntry = ChartDataEntry(x: 0, y: 0)
            dataEntries.append(dataEntry)
        }
    }

    //Set LineChartDataSet according to requirement
    func setupChartData() {
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "AQI for " + self.cityModel.city)
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawIconsEnabled = true
        chartDataSet.setColor(.systemBlue)
        chartDataSet.mode = .linear
        chartDataSet.setCircleColor(.systemBlue)
        if let font = UIFont(name: "Helvetica Neue", size: 10) {
            chartDataSet.valueFont = font
        }

        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.labelPosition = .bottom
    }

    //Helper method to bindData() for updating new city's history data
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }

        dataEntries.append(newDataEntry)
        chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)

        chartView.notifyDataSetChanged()
        chartView.moveViewToX(newDataEntry.x)
    }
}
