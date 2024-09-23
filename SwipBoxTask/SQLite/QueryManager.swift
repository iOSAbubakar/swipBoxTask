//
//  QueryManager.swift
//  SwipBoxTask
//
//  Created by Smart-IS on 23/09/2024.
//

import Foundation
class QueryManager {
    
    static let addMovies = "insert into popularMovies(id, title, releaseDate, overview, posterPath) values (?,?,?,?,?)"
    static let deleteMovies = "DELETE from popularMovies where 1=1"
    static let getMovies = "select * from popularMovies"
}
