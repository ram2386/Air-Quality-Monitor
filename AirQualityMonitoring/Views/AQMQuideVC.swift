//
//  AQMQuideVC.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMGuideVC view class does is :**
//1. In AQMListVC screen, there is a button on right of navigation bar to get to this screen
//2. User can see color respresentation based on Air Quality Monitor Index data


import UIKit
import RxSwift
import RxCocoa

class AQMQuideVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    //Model instance
    private var viewModel: AQMQuideViewModel?

    //Thread safe bag that disposes added disposables on `deinit`.
    private var bag = DisposeBag()

    //Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initilise the view model
        viewModel = AQMQuideViewModel()

        //Bind data to table
        bindTableData()

        //Setup the record
        viewModel?.setupAQMGuide()
    }

    func bindTableData() {
        //Bind items to table
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: "AQMQuideTableViewCell", cellType: AQMQuideTableViewCell.self)) {row, model, cell in
            cell.guideData = model
        }.disposed(by: bag)

        //Set delegate
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
}

//Delegate methods for UI changes in table view
extension AQMQuideVC: UITableViewDelegate {
    //Cell height is defined by this delegate method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
