//
//  NYTimesTimesApp.swift
//  NYTimesTimes
//
//  Created by ali naveed on 12/08/2025.
//

import SwiftUI

@main
struct NYTimesTimesApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleListModuleBuilder.makeView()
        }
    }
}
