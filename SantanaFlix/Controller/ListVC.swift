//
//  ListVC.swift
//  SantanaFlix
//
//  Created by André Santana on 27/02/2021.
//

import UIKit

class ListVC: UITableViewController, UIAnimatable {
    private let tableViewId = "tableCellId"
    
    private lazy var viewModel: MovieVM = {
        let viewModel = MovieVM()
        viewModel.set(delegate: self)
        return viewModel
    }()
                
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingAnimation()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UIScreen.main.bounds.width / 2
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: tableViewId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewId, for: indexPath) as! TableViewCell
        
        switch indexPath.section {
        case 0: cell.movie = viewModel.nowPlayingMovies
        case 1: cell.movie = viewModel.upcomingMovies
        case 2: cell.movie = viewModel.topRatedMovies
        case 3: cell.movie = viewModel.popularMovies
        default:
            cell.movie = Movie(results: [])
        }
        cell.set(parent: self)
        cell.alertDelegate = self
        cell.set(title: viewModel.movieListSections[indexPath.section])
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.movieListSections.count

    }
}

extension ListVC: MovieVMDelegate {
    func handler(fetching finished: Bool, error: ServiceError?) {        
        if let error = error {
            showAlert("Service Error", message: error.localizedDescription)
            return
        }
        tableView.reloadData()
        hideLoadingAnimation()
    }
}

extension ListVC: TableViewCellAlertDelegate {
    func showAlert() {
        showAlert("Poor Quality", message: "The movie seems to have poor quality!")
    }
}
