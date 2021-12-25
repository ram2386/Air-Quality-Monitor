//
//  AQMListVC.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMListVC view class does is :**
//1. This is first screen or home page after launch screen
//2. City wise air quality index data is mapped in AQMCityDataModel which is displayed in UITableView
//3. User can view city's history data in chart representation by tapping on UITableViewCell
//4. There is a button on right of navigation bar to go info screen where user can see color respresentation based on air quality index data

import UIKit
import RxSwift
import RxCocoa

class AQMListVC: UIViewController {

    //Model instance
    private var viewModel: AQMListViewModel?

    //Thread safe bag that disposes added disposables on `deinit`.
    private var bag = DisposeBag()

    //UITableView instance
    @IBOutlet var tableView: UITableView!

    //Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()

        //Bar button item for info screen
        let infoBarButtonItem = UIBarButtonItem(image: UIImage(named: "info"), style: .done, target: self, action: #selector(infoTapped))
        //Use in UITest for button action
        infoBarButtonItem.accessibilityIdentifier = "infoNavBarRightItem"
        infoBarButtonItem.isAccessibilityElement = true
        //Set right bar button item
        self.navigationItem.rightBarButtonItem = infoBarButtonItem

        //Use in UITest for table view
        tableView.accessibilityIdentifier = "table--cityTableView"

        //Model provided for table
        viewModel = AQMListViewModel(dataProvider: AQMDataProvider())

        //Bind data to table
        bindTableData()
    }

    //Bind ListViewModel's items to get updated CityDataModel data. Also tapping on cell is handled here
    func bindTableData() {

        //Bind items to table
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: "AQMCityDataTableViewCell", cellType: AQMCityDataTableViewCell.self)) {row, model, cell in
            cell.cityData = model
        }.disposed(by: bag)

        //Bind a model selected handler
        tableView.rx.modelSelected(AQMCityDataModel.self).bind { item in
            let cityDetail: AQMGraphVC = self.storyboard?.instantiateViewController(identifier: "AQMGraphVC") as! AQMGraphVC
            cityDetail.cityModel = item
            self.navigationController?.pushViewController(cityDetail, animated: true)
        }.disposed(by: bag)


        //Set delegate
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }

    //Life cycle method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Subscribe to AQIs Socket Connection
        viewModel?.subscribe()
    }

    //Life cycle method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //Unsubscribe
        viewModel?.unsubscribe()
    }

    //IBAction for right navigation bar item for info screen
    @objc func infoTapped(_ barButtonItem: UIBarButtonItem) {
        let infoDetail: AQMQuideVC = self.storyboard?.instantiateViewController(identifier: "AQMQuideVC") as! AQMQuideVC
        infoDetail.preferredContentSize = CGSize(width: Int(self.view.frame.width) - 30, height: (AQMIndexClassification.allCases.count) * 60 + 5)
        infoDetail.modalPresentationStyle = .popover
        let popoverVC = infoDetail.popoverPresentationController
        popoverVC?.barButtonItem = barButtonItem
        popoverVC?.delegate = self
        popoverVC?.permittedArrowDirections = .any
        self.present(infoDetail, animated: true, completion: nil)
    }

    //Life cycle method
    deinit {
        //Unsubscribe
        viewModel?.unsubscribe()
    }
}

//Delegate methods for UI changes in table view
extension AQMListVC: UITableViewDelegate {
    //Cell height is defined by this delegate method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

//MARK: UIPopoverPresentationControllerDelegate
extension AQMListVC:UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

