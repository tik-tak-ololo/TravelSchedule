//
//  ScheduleCardView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

struct ScheduleCardView: View {

    let item: ScheduleItem

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()

    var body: some View {
        VStack(spacing: 18) {
            carrierHeader

            timeline
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.scheduleCardBackground)
        }
    }

    private var carrierHeader: some View {
        HStack(spacing: 8) {
            carrierLogo

            VStack(alignment: .leading, spacing: 2) {
                Text(item.carrier.title)
                    .font(.system(size: 17))
                    .foregroundStyle(.schedulePrimaryText)

                if let transferDescription = item.transferDescription {
                    Text(transferDescription)
                        .font(.system(size: 12))
                        .foregroundStyle(.red)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(dateFormatter.string(from: item.departureDate))
                .font(.system(size: 12))
                .foregroundStyle(.schedulePrimaryText)
        }
    }

    @ViewBuilder
    private var carrierLogo: some View {
        if UIImage(named: item.carrier.logoAssetName) != nil {
            Image(item.carrier.logoAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 38, height: 38)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Image(systemName: "tram.fill")
                .font(.system(size: 18))
                .foregroundStyle(.red)
                .frame(width: 38, height: 38)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var timeline: some View {
        HStack(spacing: 8) {
            Text(timeFormatter.string(from: item.departureDate))
                .font(.system(size: 17))
                .foregroundStyle(.schedulePrimaryText)

            Rectangle()
                .fill(Color.scheduleLine)
                .frame(height: 1)

            Text(durationText)
                .font(.system(size: 12))
                .foregroundStyle(.schedulePrimaryText)
                .fixedSize()

            Rectangle()
                .fill(Color.scheduleLine)
                .frame(height: 1)

            Text(timeFormatter.string(from: item.arrivalDate))
                .font(.system(size: 17))
                .foregroundStyle(.schedulePrimaryText)
        }
    }

    private var durationText: String {
        let totalMinutes = max(
            Int(item.duration / 60),
            0
        )

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if minutes == 0 {
            return "\(hours) \(hourWord(for: hours))"
        }

        return "\(hours) ч \(minutes) мин"
    }

    private func hourWord(for value: Int) -> String {
        let lastTwoDigits = value % 100
        let lastDigit = value % 10

        if (11...14).contains(lastTwoDigits) {
            return "часов"
        }

        switch lastDigit {
        case 1:
            return "час"
        case 2...4:
            return "часа"
        default:
            return "часов"
        }
    }
}

//private extension Color {
//
//    static let scheduleCardBackground = Color(
//        light: UIColor(
//            red: 239 / 255,
//            green: 239 / 255,
//            blue: 239 / 255,
//            alpha: 1
//        ),
//        dark: UIColor(
//            red: 239 / 255,
//            green: 239 / 255,
//            blue: 239 / 255,
//            alpha: 1
//        )
//    )
//
//    static let schedulePrimaryText = Color(
//        light: .black,
//        dark: .black
//    )
//
//    static let scheduleLine = Color(
//        uiColor: UIColor(
//            red: 196 / 255,
//            green: 196 / 255,
//            blue: 196 / 255,
//            alpha: 1
//        )
//    )
//
//    init(
//        light: UIColor,
//        dark: UIColor
//    ) {
//        self.init(
//            uiColor: UIColor { traits in
//                traits.userInterfaceStyle == .dark
//                    ? dark
//                    : light
//            }
//        )
//    }
//}
