//
//  Movie.swift
//  SantanaFlix
//
//  Created by André Santana on 27/02/2021.
//

import Foundation

struct Movie: Decodable {
    let results: [MovieDetail]
}

struct MovieDetail: Decodable {
    let posterPath, title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
    }
}
