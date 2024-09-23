//
//  MovieDetailViewController.swift
//  SwipBoxTask
//
//  Created by Smart-IS on 21/09/2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var imageViewPosterSmall: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelLength: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    
    var movieID : Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        fetchMovieDetails(movieID: "\(String(describing: movieID ?? 0))")
    }
    // MARK: - Utilities
    func setupView(movieDetails: MovieDetail){
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movieDetails.backdropPath ?? "")")
        self.imageViewPoster.sd_setImage(with: imageURL)
        
        let imageURLsmall = URL(string: "https://image.tmdb.org/t/p/w500\(movieDetails.posterPath ?? "")")
        self.imageViewPosterSmall.sd_setImage(with: imageURLsmall)
        
        labelName.text = movieDetails.originalTitle
        labelReleaseDate.text = "Release Date: \(movieDetails.releaseDate)"
        labelOverview.text = movieDetails.overview
        
        let hours = calculateTime(movieDetails.runtime).hours
        let minutes = calculateTime(movieDetails.runtime).leftMinutes
        
        labelLength.text = "\(hours)h \(minutes)min"
        labelLanguage.text = movieDetails.originalLanguage.uppercased()
        labelRating.text = "\(movieDetails.voteAverage)"
        
    }
    
    //Return type Tuple
    func calculateTime(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    
    // MARK: - APIs
    func fetchMovieDetails(movieID : String) {
        guard let url = URL(string: APIEndpoint.getMovieDetails(movieID: movieID).path) else { return }
        
        APIClient.shared.fetchData(from: url) { (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let movieDetail):
                self.setupView(movieDetails: movieDetail)
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func tapBackButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
