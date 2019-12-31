//
//  MovieDetailsModel.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 27.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation

struct MovieDetailsModel: Decodable  {
    let id:Int!
    let posterPath: String
    var video: Bool
    let backdrop: String
    let title: String
    var releaseDate: String
    var rating: Double
    let overview: String
    let popularity: Double
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", video, backdrop = "backdrop_path", title, releaseDate = "release_date", rating = "vote_average", overview, genres, popularity
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

