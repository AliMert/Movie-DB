//
//  MovieApi.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 26.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation
import Moya

enum MovieDBApi {
    case popularMovies(page:Int)
    case topRatedMovies(page:Int)
    case nowPlayingMovies(page:Int)
    case movieDetail(id:Int)
    case movieCredits(id:Int)
    
    case popularTV(page:Int)
    case topRatedTV(page:Int)
    case tvDetail(id:Int)
    case tvCredits(id:Int)
}

extension MovieDBApi: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/") else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        let moviePath = "movie/"
        let tvPath = "tv/"
        
        switch self {
        case .topRatedMovies:
            return moviePath + "top_rated"
        case .nowPlayingMovies:
            return moviePath + "now_playing"
        case .popularMovies:
            return moviePath + "popular"
        case .movieDetail(let id):
            return moviePath + "\(id)"
        case .movieCredits(let id):
            return moviePath + "\(id)/credits"
        
        case .topRatedTV:
            return tvPath + "top_rated"
        case .popularTV:
            return tvPath + "popular"
        case .tvDetail(let id):
            return tvPath + "\(id)"
        case .tvCredits(let id):
            return tvPath + "\(id)/credits"
        }
        

    }
    
    var method: Moya.Method {
        switch self {
        case .topRatedMovies, .nowPlayingMovies, .popularMovies, .movieDetail, .movieCredits, .popularTV, .topRatedTV, .tvDetail, .tvCredits:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .movieDetail, .movieCredits, .tvDetail, .tvCredits:
            return ["api_key": API.apiKey, "language": "en"]
        case .topRatedMovies(let page), .nowPlayingMovies(let page), .popularMovies(let page), .popularTV(let page), .topRatedTV(let page):
            return ["page": page, "api_key": API.apiKey, "language": "en"]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .popularMovies, .topRatedMovies, .nowPlayingMovies, .movieDetail, .movieCredits, .topRatedTV, .popularTV, .tvDetail, .tvCredits:
            return URLEncoding.queryString
        }
    }
    
    var task: Task {
        switch self {
        case .popularMovies, .topRatedMovies, .nowPlayingMovies, .movieDetail, .movieCredits, .topRatedTV, .popularTV, .tvDetail, .tvCredits:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
               return Data()
       }
       
       var headers: [String : String]? {
           return ["Authorization": "Bearer \(API.accessToken)", "Content-Type":  "application/json;charset=utf-8"]
       }

}


class CompleteUrlLoggerPlugin : PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url?.absoluteString ?? "Something is wrong")
    }
}
