//
//  TVModel.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 28.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation

enum TVTypes: Int {
    case topRated = 0
    case popular
    
    static func toString(_ type: TVTypes) -> String {
        switch type {
        case topRated:
            return "Top Rated"
        case popular:
            return "Popular"
        }
    }
}

struct APIResultsTV: Decodable {
    let page: Int
    let numResults: Int
    let numPages: Int
    let tv: [TVModel]
    
    private enum CodingKeys: String, CodingKey {
        case page, numResults = "total_results", numPages = "total_pages", tv  = "results"
    }
}

struct TVModel: Decodable  {
    let id:Int!
    let posterPath: String
    let backdrop: String
    let name: String
    var releaseDate: String
    var rating: Double
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", backdrop = "backdrop_path", name, releaseDate = "first_air_date", rating = "vote_average", overview
    }
}



