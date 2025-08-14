//
//  Media.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
struct Media: Codable {
    let type: String?
    let caption: String?
    let mediaMetadata: [MediaMetadata]?

    enum CodingKeys: String, CodingKey {
        case type, caption
        case mediaMetadata = "media-metadata"
    }
}

