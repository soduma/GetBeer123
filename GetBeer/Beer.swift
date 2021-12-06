//
//  Beer.swift
//  GetBeer
//
//  Created by 장기화 on 2021/12/06.
//

import Foundation

struct Beer: Decodable {
    let id: Int?
    let name, tagline, description, image_url, brewers_tips: String?
    let food_pairing: [String]?
    
    var hashTag: String {
        let tags = tagline?.components(separatedBy: ". ")
        let hashtags = tags?.map {
            "#" + $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: "#")
        }
        return hashtags?.joined(separator: " ") ?? ""
    }
}
