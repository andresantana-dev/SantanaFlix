//
//  ServiceAPI.swift
//  SantanaFlix
//
//  Created by André Santana on 28/02/2021.
//

import Foundation

class ServiceAPI {
    
    // MARK: - Properties
    
    static let shared = ServiceAPI()
    private init() {}
    
    private let apiKey = ""
    private let apiURL = "https://api.themoviedb.org/3"
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Methods
    
    func fetchMovies(endpoint: MovieListEndpoint, completion: @escaping(Result<Movie, ServiceError>) -> Void) {
        guard let url = URL(string: "\(apiURL)/movie/\(endpoint.rawValue)") else {
            self.executeHandlerInMainThread(with: .failure(.invalidEndpoint), completion: completion)
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            self.executeHandlerInMainThread(with: .failure(.invalidEndpoint), completion: completion)
            return
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            self.executeHandlerInMainThread(with: .failure(.invalidEndpoint), completion: completion)
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if error != nil {
                self.executeHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let moviesResponse = try JSONDecoder().decode(Movie.self, from: data)
                self.executeHandlerInMainThread(with: .success(moviesResponse), completion: completion)
            } catch {
                self.executeHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }
        dataTask?.resume()
    }
    
    private func executeHandlerInMainThread(with result: Result<Movie, ServiceError>, completion: @escaping(Result<Movie, ServiceError>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
