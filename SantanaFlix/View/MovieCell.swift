//
//  MovieCell.swift
//  SantanaFlix
//
//  Created by André Santana on 01/03/2021.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var voteImageView: UIImageView!
    
    var viewModel: MovieDetailsVM? {
        didSet {
            configureUI()
            setupPosterAndVote()
        }
    }
    
    private func setupPosterAndVote() {        
        posterImageView.kf.setImage(with: viewModel?.poster)
        guard let isHidden = viewModel?.isVoteAverageGood else { return }
        voteImageView.isHidden = !isHidden
    }
    
    private func configureUI() {
        posterImageView.contentMode = .scaleAspectFit
        voteImageView.layer.zPosition = 1
        self.backgroundColor = .black
//        posterImageView.backgroundColor = .systemPink
    }
}
