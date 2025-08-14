//
//  ArticleDetailView.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = article.thumbnailURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty: ProgressView().frame(maxWidth: .infinity)
                        case .success(let image):
                            image.resizable().scaledToFit().cornerRadius(12)
                        case .failure: EmptyView()
                        @unknown default: EmptyView()
                        }
                    }
                }

                Text(article.displayTitle).font(.title2.bold())
                Text(article.displayByline).font(.subheadline).foregroundStyle(
                    .secondary
                )
                if let date = article.formattedDate {
                    Text(date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let url = URL(string: article.url) {
                    Link("Open in Browser", destination: url)
                        .font(.headline)
                        .accessibilityIdentifier("OpenInBrowserLink")
                }

            }.padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(
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
