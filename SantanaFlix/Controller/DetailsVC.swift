//
//  DetailsVC.swift
//  SantanaFlix
//
//  Created by André Santana on 02/03/2021.
//

import UIKit
import Kingfisher

class DetailsVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private var viewModel: MovieDetailsVM? = nil
    
    public func set(viewModel: MovieDetailsVM) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .black
        voteLabel.text = "Vote: \(String(viewModel?.voteAverage ?? 0.0))"
        posterImageView.kf.setImage(with: viewModel?.poster)
        posterImageView.layer.cornerRadius = 5.0
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderColor = UIColor.white.cgColor
        posterImageView.layer.borderWidth = 2.0
        posterImageView.contentMode = .scaleAspectFill
        voteLabel.textColor = .white
        backButton.backgroundColor = .white
        backButton.setTitleColor(.black, for: .normal)
        backButton.layer.cornerRadius = 10
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Action
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
