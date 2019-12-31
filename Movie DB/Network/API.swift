//
//  API.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 26.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation
import Moya
import Result

class API {
    static let apiKey = "a378b5d1ec04d6c21a8ae54507b55641"
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhMzc4YjVkMWVjMDRkNmMyMWE4YWU1NDUwN2I1NTY0MSIsInN1YiI6IjVlMDM2MDM3MjZkYWMxMDAxMjY4YzJjNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.k4UKfJ5B1ZZJAWHWAGCEQmLyUP2QzhHR54VTeHMr6-8"
    
    static let provider = MoyaProvider<MovieDBApi>(plugins: [CompleteUrlLoggerPlugin()])
   

    private static func decodeAndGetMoviesFrom(_ result: Result<Moya.Response, MoyaError>, completion: @escaping ([Movie])->()) {
        switch result {
            case let .success(response):
                do {
                    let result = try JSONDecoder().decode(APIResults.self, from: response.data)
                    completion(result.movies)
                }
                catch let err {
                    print(err)
                }
            
            case let .failure(error):
                print(error)
        }
    }
    
    private static func decodeAndGetTVModelFrom(_ result: Result<Moya.Response, MoyaError>, completion: @escaping ([TVModel])->()) {
           switch result {
               case let .success(response):
                   do {
                       let result = try JSONDecoder().decode(APIResultsTV.self, from: response.data)
                       completion(result.tv)
                   }
                   catch let err {
                       print(err)
                   }
               
               case let .failure(error):
                   print(error)
           }
       }
    
    
    static func getPopularMovies(page: Int, completion: @escaping ([Movie])->()) {
        provider.request(.popularMovies(page:page)) { result in
            decodeAndGetMoviesFrom(result) { movies in
                completion(movies)
            }
        }
    }
    
    static func getNowPlayingMovies(page: Int, completion: @escaping ([Movie])->()) {
        provider.request(.nowPlayingMovies(page:page)) { result in
            decodeAndGetMoviesFrom(result) { movies in
                completion(movies)
            }
        }
    }

      
    static func getTopRatedMovies(page: Int, completion: @escaping ([Movie])->()) {
        provider.request(.topRatedMovies(page:page)) { result in
            decodeAndGetMoviesFrom(result) { movies in
                completion(movies)
            }
        }
    }

    
    static func getMoviesModel(movieType: MovieTypes, page: Int, completion: @escaping ([Movie])->()) {
        
        var target : MovieDBApi
        switch movieType {
        case .popular:
            target = MovieDBApi.popularMovies(page: page)
        case.topRated:
            target = MovieDBApi.topRatedMovies(page: page)
        case .nowPlaying:
            target = MovieDBApi.nowPlayingMovies(page: page)
        }
        
        provider.request(target) { result in
            decodeAndGetMoviesFrom(result) { moviesModel in
                completion(moviesModel)
            }
        }
    }
    
    
    static func getTVModel(tvType: TVTypes, page: Int, completion: @escaping ([TVModel])->()) {
        
        var target : MovieDBApi
        switch tvType {
        case .popular:
            target = MovieDBApi.popularTV(page: page)
        case.topRated:
            target = MovieDBApi.topRatedTV(page: page)
        }
        
        provider.request(target) { result in
            decodeAndGetTVModelFrom(result) { tvModel in
                completion(tvModel)
            }
        }
    }
    
    
    static func getMovieDetails(id: Int, completion: @escaping (MovieDetailsModel)->()) {
        provider.request(.movieDetail(id: id)) { result in
           
            switch result {
                case let .success(response):
                    //print(try? response.mapJSON())
                    do {
                        let result = try JSONDecoder().decode(MovieDetailsModel.self, from: response.data)
                        completion(result)
                    }
                    catch let err {
                        print(err)
                    }
                
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    

    
    static func getTVDetails(id: Int, completion: @escaping (TVDetailsModel)->()) {
        provider.request(.tvDetail(id: id)) { result in

            switch result {
                case let .success(response):
                    do {
                        let result = try JSONDecoder().decode(TVDetailsModel.self, from: response.data)
                        completion(result)
                    }
                    catch let err {
                        print(err)
                    }
                
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    
    private static func didgetResultFromCastAndCrewRequest(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (CastAndCrewModel)->()) {
        switch result {
            case let .success(response):
                do {
                    let result = try JSONDecoder().decode(CastAndCrewModel.self, from: response.data)
                    var newCrew = [CrewModel]()
                    if let director = result.crew.first(where: {$0.job == "Director"}) {
                          newCrew = [director]
                    }
                    
                    let newResult = CastAndCrewModel(cast: result.cast, crew: newCrew)
                    completion(newResult)
                }
                catch let err {
                    print(err)
                }
            
            case let .failure(error):
                print(error)
        }
    }
    
    static func getCastAndCrew(id: Int, fromTV: Bool?=nil, fromMovie: Bool?=nil, completion: @escaping (CastAndCrewModel)->()) {
        
        if fromTV == true {
            provider.request(.tvCredits(id: id)) { result in
                didgetResultFromCastAndCrewRequest(result) { finalResult in
                    completion(finalResult)
                }
            }
        }
        else if fromMovie == true {
            provider.request(.movieCredits(id: id)) { result in
                didgetResultFromCastAndCrewRequest(result) { finalResult in
                    completion(finalResult)
                }
            }
        }
        else {
            print("\n\nERROR:: API.getCastAndCrew function requested nothing!!\n\n")
        }
    }
    
    
    //    static func requestTVShows(_ vc: TVTableViewController, page:Int=1) {
    //        self.getTVModel(tvType: .topRated, page: page) { TVModel in
    //            print("\n\nTop Rated TV Shows is received")
    //            vc.topRatedTVs = TVModel
    //        }
    //
    //        self.getTVModel(tvType: .popular, page: page) { TVModel in
    //            print("\n\nPopular TV Shows is received")
    //            vc.popularTVs = TVModel
    //        }
    //    }
    //
}
