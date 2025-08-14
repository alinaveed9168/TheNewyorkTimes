//
//  ArticleRowView.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import SwiftUI

struct ArticleRowView: View {
    let article: Article
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            if let url = article.thumbnailURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: ProgressView().frame(width: 64, height: 64)
                    case .success(let image):
                        image.resizable().scaledToFill().frame(
                            width: 64,
                            height: 64
                        ).clipped().cornerRadius(8)
                    case .failure:
                        Color.gray.frame(width: 64, height: 64).cornerRadius(8)
                    @unknown default:
                        Color.gray.frame(width: 64, height: 64).cornerRadius(8)
                    }
                }
            } else {
                Color.gray.opacity(0.2).frame(width: 64, height: 64)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(article.displayTitle).font(.headline).lineLimit(2)
                Text(article.displayByline).font(.subheadline).foregroundStyle(
                    .secondary
                ).lineLimit(1)
                if let date = article.formattedDate {
                    Text(date).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(
            article: Article(
                id: 1,
                url: "test",
                title: "title",
                byline: "byline",
                publishedDate: "2025/08/13",
                updated: "helloworld",
                media: nil
            )
        )
    }
}
