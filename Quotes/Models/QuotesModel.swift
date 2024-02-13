//
//  QuotesModel.swift
//  Quotes
//
//  Created by Adriano Rodrigues Vieira on 05/02/24.
//

import Foundation

struct QuotesModel: Decodable {
    let contents: QuotesContentModel?
}

struct QuotesContentModel: Decodable {
    let quotes: [SingleQuoteModel]?
}

struct SingleQuoteModel: Decodable {
    let quote: String?
    let lenght: String?
    let author: String?
    let tags: [String]?
    let category: String?
}
