//
//  ExploreCard.swift
//  ANF Code Test
//
//  Created by Irfan Mohammed on 10/24/25.
//


import Foundation

struct ExploreCard: Codable {
    let title: String
    let backgroundImage: String
    let topDescription: String?
    let bottomDescription: String?
    let promoMessage: String?
    let content: [ContentItem]?
}

struct ContentItem: Codable {
    let target: String
    let title: String
    let elementType: String?
}
