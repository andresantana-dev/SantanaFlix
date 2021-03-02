//
//  MovieDetailsVM.swift
//  SantanaFlix
//
//  Created by André Santana on 02/03/2021.
//

import Foundation

class MovieDetailsVM {
    private var movieDetails: MovieDetail? = nil
    
    init() { }
    
    public func set(movieDetails: MovieDetail) {
        self.movieDetails = movieDetails
    }
    
    var poster: URL {
        guard let movieUrl = self.movieDetails?.posterPath else { return URL(string: "")! }
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movieUrl)") else { return URL(string: "")! }
        return url
    }
    
    var isVoteAverageGood: Bool {
        return self.movieDetails?.voteAverage ?? 0.0 >= 6.0 ? true : false
    }
    
    var voteAverage: Double {
        return self.movieDetails?.voteAverage ?? 0.0
    }
}
