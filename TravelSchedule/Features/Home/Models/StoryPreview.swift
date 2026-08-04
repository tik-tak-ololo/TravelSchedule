//
//  StoryPreview.swift
//  TravelSchedule
//

import Foundation

struct StoryPreview: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let description: String
    let accessibilityLabel: String

    var fullImageName: String {
        "Full\(imageName)"
    }
}
