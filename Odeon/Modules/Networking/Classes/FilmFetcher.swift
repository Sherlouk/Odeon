//
//  FilmFetcher.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import Moya
import Result

class FilmFetcher: Cancellable {
    
    struct Film {
        let odeonFilmDetails: FilmDetails
        let movieDetails: MovieDetails
    }
    
    enum Error: Swift.Error {
        case missingResult
    }
    
    let filmTitle: String
    let odeonFilmID: String
    let releaseYear: Int
    
    var cancellable: Cancellable?
    
    init(film: OdeonFilm) {
        filmTitle = film.title
        odeonFilmID = String(film.id)
        releaseYear = 2018 // TODO: make this dynamic
    }
    
    // MARK: - Fetch
    
    @discardableResult
    func fetch(completion: @escaping (Result<Film, MoyaError>) -> Void) -> Cancellable {
        fetchODEON { odeonResult in
            
            switch odeonResult {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let odeonResponse):
                self.searchMovieDB { movieDBResult in
                    
                    switch movieDBResult {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success(let movieDBResponse):
                        
                        guard let result = movieDBResponse.results.first else {
                            completion(.failure(.underlying(Error.missingResult, nil)))
                            return
                        }
                        
                        self.fetchMovieDB(movieID: result.id) { movieDBMovieResult in
                            
                            switch movieDBMovieResult {
                            case .failure(let error):
                                completion(.failure(error))
                                
                            case .success(let movieDBMovieResponse):
                                completion(.success(Film(
                                    odeonFilmDetails: odeonResponse.data,
                                    movieDetails: movieDBMovieResponse
                                )))
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        
        return self
    }
    
    private func fetchODEON(completion: @escaping (Result<DataWrapperGenericResponse<FilmDetails>, MoyaError>) -> Void) {
        let provider = MoyaProvider<OdeonService>()
        cancellable = provider.requestDecode(.filmDetailsWithCinemas(filmID: odeonFilmID), completion: completion)
    }
    
    private func searchMovieDB(completion: @escaping (Result<ResultsWrapperGenericResponse<FilmSearchResult>, MoyaError>) -> Void) {
        let provider = MoyaProvider<MovieDBService>()
        cancellable = provider.requestDecode(.searchMovie(query: filmTitle, year: releaseYear), completion: completion)
    }
    
    private func fetchMovieDB(movieID: Int, completion: @escaping (Result<MovieDetails, MoyaError>) -> Void) {
        let provider = MoyaProvider<MovieDBService>()
        cancellable = provider.requestDecode(.getMovieDetails(movieID: movieID), completion: completion)
    }
    
    // MARK: - Cancellable
    
    var isCancelled: Bool {
        return cancellable?.isCancelled ?? false
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
}
