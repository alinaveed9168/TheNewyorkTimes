//
//  NYTEndpoints.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import Foundation
import Combine

enum NYTEndpoints {
    static func mostPopular(
        section: String = "all-sections",
        period: Int = 7
    ) -> Endpoint<MostViewedResponse> {
        Endpoint(
            path: "/svc/mostpopular/v2/mostviewed/\(section)/\(period).json"
        )
    }
}
