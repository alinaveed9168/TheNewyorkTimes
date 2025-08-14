//
//  EmptyStateView.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(title: "No Data Found", message: "Message")
    }
}
