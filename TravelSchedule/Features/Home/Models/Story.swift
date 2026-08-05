//
//  Story.swift
//  TravelSchedule
//

import Foundation

struct Story: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let description: String
    let accessibilityLabel: String
    var isViewed = false

    var fullImageName: String {
        "Full\(imageName)"
    }
}
