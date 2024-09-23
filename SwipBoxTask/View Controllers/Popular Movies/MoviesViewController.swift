//
//  MoviesViewController.swift
//  SwipBoxTask
//
//  Created by Smart-IS on 21/09/2024.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableViewMovies: UITableView!
    @IBOutlet var internetLabelHeightConstraint: NSLayoutConstraint!
    
    let cellReuseIdentifierMovie = "MovieTableViewCell"
    var moviesList : [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            internetLabelHeightConstraint.constant = 0
            fetchMovieData()
        }else{
            print("Internet Connection not Available!")
            internetLabelHeightConstraint.constant = 32
            reloadTableView(moviesList: getMovies())
            
        }

    }
    // MARK: - Utilities
    func setupTableView() {
        self.tableViewMovies.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifierMovie)
        self.tableViewMovies.register(UINib(nibName: cellReuseIdentifierMovie, bundle: nil), forCellReuseIdentifier: cellReuseIdentifierMovie)
    }
    
    func reloadTableView(moviesList: [Movie]){
        self.moviesList = moviesList
        self.tableViewMovies.reloadData()
    }
    
    // MARK: - APIs
    func fetchMovieData() {
        
        guard let url = URL(string: APIEndpoint.getMovies.path) else { return }
        APIClient.shared.fetchData(from: url) { (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let movies):
                
                self.reloadTableView(moviesList: movies.results)
                self.addMoviesInDB(moviesList: movies.results)
                
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
    
    // MARK: - Database
    private func addMoviesInDB(moviesList : [Movie]) {
        
        deleteTableRecords(query: QueryManager.deleteMovies)
        for movie in moviesList {
            if SQLiteDB.shared.open() {
                
                let objList = SQLiteDB.shared.execute (
                    sql: QueryManager.addMovies,
                    parameters: [
                        movie.id ?? -1,
                        movie.title ?? "",
                        movie.releaseDate ?? "",
                        movie.overview ?? "",
                        movie.posterPath ?? ""
                    ]
                )
                print(objList)
            }
            
        }
        SQLiteDB.shared.closeDB()
        
        
    }
    
    private func deleteTableRecords(query : String)  {
        
        if SQLiteDB.shared.open() {
            
            let objList = SQLiteDB.shared.execute (
                sql: query
            )
            print(objList)
        }
        
        SQLiteDB.shared.closeDB()
    }
    
    private func getMovies() -> [Movie] {
        
        if SQLiteDB.shared.open() {
            
            let objList = SQLiteDB.shared.query (
                sql: QueryManager.getMovies
            )
            
            do {
                let json = try JSONSerialization.data(withJSONObject: objList)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedMovies = try decoder.decode([Movie].self, from: json)
                return decodedMovies
            } catch {
                print(error)
            }
        }
        
        SQLiteDB.shared.closeDB()

        return []
        
    }
    
    
    
    
}
// MARK: - UITableView
extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierMovie) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        if let movieModel = self.moviesList?[indexPath.row] {
            cell.configure(movieData: movieModel)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Reachability.isConnectedToNetwork(){
            if let movieID = self.moviesList?[indexPath.row].id {
                
                if let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                    
                    movieDetailViewController.movieID = movieID
                    
                    if let navigator = navigationController {
                        navigator.pushViewController(movieDetailViewController, animated: true)
                    }
                }
            }
        }else{
            self.presentAlertWithTitleAndMessage(
                title: Constant.alertTitle,
                message: Constant.alertMessage,
                options: Constant.buttonTitle) { _ in}
        }
    }
    
}
