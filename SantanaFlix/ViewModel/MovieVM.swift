//
//  MovieVM.swift
//  SantanaFlix
//
//  Created by André Santana on 27/02/2021.
//

import UIKit

protocol MovieVMDelegate: AlertHelper {
    func handler(fetching finished: Bool, error: ServiceError?)
}

class MovieVM: NSObject {
    
    // MARK: - Properties
    
    private weak var delegate: MovieVMDelegate? = nil
    
    private var isSuccess = true
    private var fetchError: ServiceError? = nil
    
    public var movieListSections = ["Now Playing", "Upcoming", "Top Rated", "Popular"]
    public var nowPlayingMovies: Movie? = nil
    public var upcomingMovies: Movie? = nil
    public var topRatedMovies: Movie? = nil
    public var popularMovies: Movie? = nil
            
    override init() {
        super.init()
        fetchAllTheMovies()
    }
        
    public func set(delegate: MovieVMDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - API Methods
    
    private func fetchAllTheMovies() {
        let group = DispatchGroup()
        fetchMovies(with: .nowPlaying, group: group)
        fetchMovies(with: .upcoming, group: group)
        fetchMovies(with: .topRated, group: group)
        fetchMovies(with: .popular, group: group)
        
        group.notify(queue: .main, execute: { [self] in
            delegate?.handler(fetching: isSuccess, error: fetchError)
        })
    }

    private func fetchMovies(with endpoint: MovieListEndpoint, group: DispatchGroup) {
        group.enter()
        ServiceAPI.shared.fetchMovies(endpoint: endpoint) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.isSuccess = false
                self?.fetchError = error
            case .success(let movie):
                switch endpoint {
                case .nowPlaying:
                    self?.nowPlayingMovies = movie
                case .upcoming:
                    self?.upcomingMovies = movie
                case .topRated:
                    self?.topRatedMovies = movie
                case .popular:
                    self?.popularMovies = movie
                }
            }
            group.leave()
        }
    }
}
