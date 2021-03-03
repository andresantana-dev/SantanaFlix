//
//  TableViewCell.swift
//  SantanaFlix
//
//  Created by André Santana on 01/03/2021.
//

import UIKit


protocol TableViewCellAlertDelegate: class {
    func showAlert()
}

class TableViewCell: UITableViewCell {
    
    // MARK: - Properties

    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var alertDelegate: TableViewCellAlertDelegate? = nil
    
    private let collectionViewId = "movieCell"
    private var title: String? = ""
    private var parent: UIViewController? = nil
    
    private lazy var viewModel: MovieDetailsVM = {
        let viewModel = MovieDetailsVM()
        return viewModel
    }()
    
    var movie: Movie? {
        didSet {
            configureUI()
            configureCollectionView()
            movieCollectionView.reloadData()
        }
    }
    
    public func set(title: String) {
        self.title = title
    }
    
    public func set(parent: UIViewController) {
        self.parent = parent
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        titleLabel.text = title
        titleLabel.textColor = .white
        
        self.backgroundColor = .black
    }
    
    private func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        movieCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: collectionViewId)
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.showsHorizontalScrollIndicator = false
        movieCollectionView.collectionViewLayout = flowLayout
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.set(movieDetails: movie?.results[indexPath.row] ?? MovieDetail(posterPath: "", title: "", voteAverage: 0.0))
        if viewModel.isVoteAverageGood {
            if let detailsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
                detailsVC.set(viewModel: viewModel)
                self.parent?.navigationController?.pushViewController(detailsVC, animated: true)
            }
            return
        }
        alertDelegate?.showAlert()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movie?.results.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewId, for: indexPath) as! MovieCell
        viewModel.set(movieDetails: movie?.results[indexPath.row] ?? MovieDetail(posterPath: "", title: "", voteAverage: 0.0))
        cell.viewModel = viewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: movieCollectionView.frame.height * 0.8, height: movieCollectionView.frame.height)
    }
}
