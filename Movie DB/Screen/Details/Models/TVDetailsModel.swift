//
//  TVDetailsModel.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 29.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation


struct TVDetailsModel: Decodable  {
    let id:Int!
    let posterPath: String
    let backdrop: String
    let name: String
    var firstAirDate: String
    var lastAirDate: String?
    var rating: Double
    let overview: String
    let popularity: Double
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", backdrop = "backdrop_path", name, firstAirDate = "first_air_date", lastAirDate = "last_air_date", rating = "vote_average", overview, genres, popularity
    }
}
