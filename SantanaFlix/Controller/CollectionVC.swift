//
//  CollectionVC.swift
//  SantanaFlix
//
//  Created by André Santana on 01/03/2021.
//

import UIKit

class CollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let collectionViewId = "movieCell"
    private var movie: Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    public func set(movie: Movie) {
        self.movie = movie
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .yellow
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: collectionViewId)
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.movieDetail = movie?.results[indexPath.row]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.results.count ?? 0
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 5
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        let itemWidth = itemHeight * 300 / 444
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
