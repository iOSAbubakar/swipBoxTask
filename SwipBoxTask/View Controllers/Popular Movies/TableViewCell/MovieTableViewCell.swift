//
//  MovieTableViewCell.swift
//  SwipBoxTask
//
//  Created by Smart-IS on 21/09/2024.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewMovie: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(movieData: Movie) {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movieData.posterPath ?? "")")
        self.imageViewMovie.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")
)
        self.imageViewMovie.layer.cornerRadius = 15.0;
        self.imageViewMovie.layer.masksToBounds = true;
        
        self.labelName.text = movieData.title
        self.labelDate.text = movieData.releaseDate
        self.labelDetail.text = movieData.overview
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
