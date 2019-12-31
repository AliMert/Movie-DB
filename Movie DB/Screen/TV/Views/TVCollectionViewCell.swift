//
//  TVCollectionViewCell.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 28.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

class TVCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tvImageViewContainerView: UIView!
    @IBOutlet weak var tvImageView: UIImageView!
    @IBOutlet weak var tvLabel: UILabel!
    
    func setTVcell(tvModel: TVModel) {
        tvLabel.text = tvModel.name
        tvImageView.backgroundColor = .clear
        tvImageView.corners(15)
        tvImageViewContainerView.addShadow(offset: CGSize(width: -1, height: 3), color: .darkGray, radius: 6, opacity: 0.6)
        tvImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: tvImageView.bounds, cornerRadius: 6).cgPath
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(tvModel.posterPath)") else {return}

        tvImageView.af_setImage(withURL: url)

    }
    
}
