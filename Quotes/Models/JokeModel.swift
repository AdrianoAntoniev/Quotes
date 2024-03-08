//
//  JokesModel.swift
//  Jokes
//
//  Created by Adriano Rodrigues Vieira on 05/02/24.
//

import Foundation

struct JokeModel: Decodable {
    let type: String?
    let setup: String?
    let punchline: String?
    let id: Int?
}
