//
//  Article.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import Foundation

struct Article: Codable {
    let id: Int
    let url: String
    let title: String
    let byline: String
    let publishedDate: String
    let updated: String?
    let media: [Media]?

    enum CodingKeys: String, CodingKey {
        case id, url, title, byline, media, updated
        case publishedDate = "published_date"
    }
}

extension Article {
    var displayTitle: String { title }
    var displayByline: String { byline }

    var formattedDate: String? {
        let input = DateFormatter()
        input.locale = Locale(identifier: "en_US_POSIX")
        input.dateFormat = "yyyy-MM-dd"

        let output = DateFormatter()
        output.locale = Locale(identifier: "en_US_POSIX")
        output.dateFormat = "MMM d, yyyy"

        if let d = input.date(from: publishedDate) {
            return output.string(from: d)
        }
        return nil
    }

    var thumbnailURL: URL? {
        guard let meta = media?.first?.mediaMetadata else { return nil }
        let best = meta.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })
        if let url = best?.url { return URL(string: url) }
        return nil
    }

    var hasValidURL: Bool { URL(string: url) != nil }
}
