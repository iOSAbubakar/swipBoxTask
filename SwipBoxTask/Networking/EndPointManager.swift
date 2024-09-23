//
//  EndPointManager.swift
//  SwipBoxTask
//
//  Created by Smart-IS on 21/09/2024.
//

import Foundation

enum APIEndpoint {
    
    case getMovies
    case getMovieDetails(movieID: String)
    
    var path: String {
        switch self {
        case .getMovieDetails(let movieID):
            return "https://api.themoviedb.org/3/movie/\(movieID)"
        case .getMovies:
            return "https://api.themoviedb.org/3/movie/popular"
        }
    }
}
