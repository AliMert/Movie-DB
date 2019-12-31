//
//  MovieCollectionViewCell.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 25.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieImageViewContainerView: UIView!
    
    func setMovie(movie: Movie) {
        movieLabel.text = movie.title
        movieImageView.backgroundColor = .clear
        movieImageView.corners(15)

        movieImageViewContainerView.addShadow(offset: CGSize(width: -1, height: 1), color: .darkGray, radius: 6, opacity: 0.71)
        movieImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: movieImageView.bounds, cornerRadius: 15).cgPath
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)") else {return}
        movieImageView.af_setImage(withURL: url)
    }
}
