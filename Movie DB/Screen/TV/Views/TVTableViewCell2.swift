//
//  TVTableViewCell2.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 28.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

class TVTableViewCell2: UITableViewCell {

    @IBOutlet weak var tvLabel: UILabel!
    @IBOutlet weak var tvImageView: UIImageView!
    @IBOutlet weak var tvImageViewContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    func setTVcell(tvModel: TVModel) {

        tvLabel.text = tvModel.name
        tvImageView.backgroundColor = .clear
        tvImageView.corners(15)
        tvImageViewContainerView.addShadow(offset: CGSize(width: -1, height: 3), color: .darkGray, radius: 6, opacity: 0.6)
        tvImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: tvImageView.bounds, cornerRadius: 6).cgPath

//        tvImageViewContainerView.layer.addShadow(radius: 15, color: .darkGray, width: 5, height: 5, opacity: 0.9)
      //  tvImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: tvImageView.bounds, cornerRadius: 15).cgPath
        
        if let releaseYear = tvModel.releaseDate.dateFormatterGetOnlyYear(), let name = tvLabel?.text {
            tvLabel.text = name + " (" + releaseYear + "-)"
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(tvModel.backdrop)") else {return}
        tvImageView.af_setImage(withURL: url)
    }

}
