//
//  ProtocolsANDExtensions.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 26.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import UIKit

// MARK: - PROTOCOL DECLARATION

protocol DetailsViewControllerDelegate {
    func didGetTVDetails(tvDetails: TVDetailsModel)
    func didGetMovieDetails(movieDetails: MovieDetailsModel)
    func didGetCastAndCrew(_ castAndCrewModel: CastAndCrewModel)
}



// MARK: - EXTENSIONS ON STRING

extension String {
    func dateFormatterGetOnlyYear() -> String? {
     let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        if let date = dateFormatterGet.date(from: self) {
            let year = dateFormatterPrint.string(from: date)
            return year
        } else {
           print("There was an error decoding the string")
        }
        return nil
    }
}


  
// MARK: - EXTENSIONS ON UIView

extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }

    func corners(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}



// MARK: - EXTENSIONS ON UINavigationBar

extension UINavigationBar {
    func makeTransparent(_ enable :Bool) {
        if enable {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            self.tintColor = UIColor.white
        } else {
            self.setBackgroundImage(nil, for: .default)
            self.shadowImage = nil
        }
        self.isTranslucent = true
    }
}
