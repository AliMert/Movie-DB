//
//  Cast & Crew Model.swift
//  Movie DB
//
//  Created by Ali Mert Özhayta on 27.12.2019.
//  Copyright © 2019 Ali Mert Özhayta. All rights reserved.
//

import Foundation


struct CastModel: Decodable  {
    let id:Int!
    let profilePath: String?
    let character: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, profilePath = "profile_path", character, name
    }
}

struct CrewModel: Decodable {
    let id: Int
    let name: String
    let job: String
    let department: String
    let profilePath: String?
    
    private enum CodingKeys: String, CodingKey {
          case id, profilePath = "profile_path", job, name, department
      }
}


struct CastAndCrewModel: Decodable {
    let cast: [CastModel]
    let crew: [CrewModel]
}


