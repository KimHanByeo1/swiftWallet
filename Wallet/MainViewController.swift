//
//  MainViewController.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/20.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainTV: UITableView!
    
    var dataSource: [MainModel] = []
    var filteredDataSource: [MainModel] = []

    var isEditMode: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTV.delegate = self
        mainTV.dataSource = self
        setupSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        selectData()
    }
    
    func selectData(){
        let MainSelectModel = MainSelectModel()
        MainSelectModel.delegate = self
        MainSelectModel.downloadItems()
        mainTV.reloadData()
    }
    
    private func setupSearchController() {

        let searchController = UISearchController(searchResultsController: nil)
 
        searchController.searchBar.placeholder = "제목을 입력해 주세요"
        // 내비게이션 바는 항상 표출되도록 설정
        searchController.hidesNavigationBarDuringPresentation = true
        // updateSearchResults(for:) 델리게이트를 사용을 위한 델리게이트 할당
        searchController.searchResultsUpdater = self
        // 뒷배경이 흐려지지 않도록 설정
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEditMode ? filteredDataSource.count : dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateViewModel = DateViewModel()
        
        cell.lblTitle.text = isEditMode ? filteredDataSource[indexPath.row].pTitle : dataSource[indexPath.row].pTitle
        
        // url 비동기 통신
        if let imageURL = isEditMode ? URL(string: filteredDataSource[indexPath.row].imageURL) : URL(string: dataSource[indexPath.row].imageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                }
            }.resume()
        }
        
        cell.lblBrandAndTime.text = isEditMode ? filteredDataSource[indexPath.row].pBrand + " · " + dateViewModel.DateCount(filteredDataSource[indexPath.row].pTime) : dataSource[indexPath.row].pBrand + " · " + dateViewModel.DateCount(dataSource[indexPath.row].pTime)
        cell.lblPrice.text = isEditMode ? numberFormatter.string(from: NSNumber(value: Int(filteredDataSource[indexPath.row].pPrice)!))! + " 원" : numberFormatter.string(from: NSNumber(value: Int(dataSource[indexPath.row].pPrice)!))! + " 원"
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredDataSource = dataSource.filter { $0.pTitle.localizedCaseInsensitiveContains(text) }
        mainTV.reloadData()
    }
}

extension MainViewController: QueryModelProtocol {
    func itemDownLoaded(items: [MainModel]) {
        dataSource = items
        self.mainTV.reloadData()
    }

}
