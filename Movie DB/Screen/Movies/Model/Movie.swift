//
//  Movie.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 26.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation

enum MovieTypes: Int {
    case nowPlaying = 0
    case topRated
    case popular
    
    static func toString(_ type: MovieTypes) -> String {
        switch type {
        case topRated:
            return "Top Rated"
        case nowPlaying:
            return "Now Playing"
        case popular:
            return "Popular"
        }
    }
}

struct APIResults: Decodable {
    let page: Int
    let numResults: Int
    let numPages: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page, numResults = "total_results", numPages = "total_pages", movies  = "results"
    }
}

struct Movie: Decodable  {
    let id:Int!
    let posterPath: String
    var videoPath: String?
    let backdrop: String
    let title: String
    var releaseDate: String
    var rating: Double
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", videoPath, backdrop = "backdrop_path", title, releaseDate = "release_date", rating = "vote_average", overview
    }
}

