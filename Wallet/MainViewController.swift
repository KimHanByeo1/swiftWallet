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

    var isEditMode: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

//    lazy var tableView: UITableView = {
//        let view = mainTV!
//        view.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
//        view.delegate = self
//        view.dataSource = self
//        view.keyboardDismissMode = .onDrag
//
//        return view
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
//        return isEditMode ? filteredDataSource.count : dataSource.count
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateViewModel = DateViewModel()
        
        cell.lblTitle.text = dataSource[indexPath.row].pTitle
        
        // url 비동기 통신
        if let imageURL = URL(string: dataSource[indexPath.row].imageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                }
            }.resume()
        }
        
        cell.lblBrandAndTime.text = dataSource[indexPath.row].pBrand + " · " + dateViewModel.DateCount(dataSource[indexPath.row].pTime)
        cell.lblPrice.text = numberFormatter.string(from: NSNumber(value: Int(dataSource[indexPath.row].pPrice)!))! + " 원"
        
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
        let MainSelectModel = MainSelectModel()
        MainSelectModel.searchItems(text)
        mainTV.reloadData()
    }
}

extension MainViewController: QueryModelProtocol {
    func itemDownLoaded(items: [MainModel]) {
        dataSource = items
        self.mainTV.reloadData()
    }

}
