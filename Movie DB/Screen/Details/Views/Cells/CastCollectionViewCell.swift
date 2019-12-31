//
//  CastCollectionViewCell.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 27.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var profileImageViewContainerView: UIView!
    
    func setCast(_ cast: CastModel) {
        nameLabel.text = cast.name
        jobLabel.text = ""
        profileImageView.corners(7)
        profileImageViewContainerView.addShadow(offset: CGSize(width: -0.5, height: 2), color: .darkGray, radius: 3, opacity: 0.6)
        profileImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: profileImageView.bounds, cornerRadius: 6).cgPath
        
        guard let path = cast.profilePath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(path)") else {
            profileImageView.image = UIImage(named: "profileNotFound")
            return
        }
        profileImageView.af_setImage(withURL: url)
   }

    func setCrew(_ crew: CrewModel) {
        nameLabel.text = crew.name
        jobLabel.text = crew.job
        profileImageView.corners(7)
        guard let path = crew.profilePath, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(path)") else {
            profileImageView.image = UIImage(named: "profileNotFound")
            return
        }
        profileImageView.af_setImage(withURL: url)
    }

}
