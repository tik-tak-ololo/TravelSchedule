//
//  ScheduleFilterView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

@MainActor
struct ScheduleFilterView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: ScheduleFilterViewModel

    private let onApply: (ScheduleFilter) -> Void

    init(
        filter: ScheduleFilter,
        onApply: @escaping (ScheduleFilter) -> Void
    ) {
        _viewModel = State(
            initialValue: ScheduleFilterViewModel(
                filter: filter
            )
        )

        self.onApply = onApply
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content

            if viewModel.isApplyButtonVisible {
                applyButton
            }
        }
        .background(.backgroundColorIOS)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                departureTimeSection

                transfersSection
                    .padding(.top, 32)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    private var departureTimeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle("Время отправления")

            VStack(spacing: 0) {
                ForEach(DepartureTimeOption.allCases) { option in
                    departureTimeRow(option)
                }
            }
            .padding(.top, 20)
        }
    }

    private var transfersSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(
                "Показывать варианты с\nпересадками"
            )

            VStack(spacing: 0) {
                ForEach(TransfersOption.allCases) { option in
                    transfersRow(option)
                }
            }
            .padding(.top, 20)
        }
    }

    private func sectionTitle(
        _ title: String
    ) -> some View {
        Text(title)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.primary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }

    private func departureTimeRow(
        _ option: DepartureTimeOption
    ) -> some View {
        Button {
            viewModel.toggleDepartureTime(option)
        } label: {
            HStack(spacing: 16) {
                Text(option.title)
                    .font(.system(size: 17))
                    .foregroundStyle(.primary)

                Spacer()

                CheckboxView(
                    isSelected: viewModel
                        .isDepartureTimeSelected(option)
                )
            }
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func transfersRow(
        _ option: TransfersOption
    ) -> some View {
        Button {
            viewModel.selectTransfersOption(option)
        } label: {
            HStack(spacing: 16) {
                Text(option.title)
                    .font(.system(size: 17))
                    .foregroundStyle(.primary)

                Spacer()

                RadioButtonView(
                    isSelected: viewModel
                        .isTransfersOptionSelected(option)
                )
            }
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var applyButton: some View {
        Button {
            onApply(viewModel.filter)
            dismiss()
        } label: {
            Text("Применить")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.travelBlue)
                }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

#Preview("Light — selected") {
    NavigationStack {
        ScheduleFilterView(
            filter: ScheduleFilter(
                departureTimeOptions: [.morning, .night],
                transfersOption: .hide
            )
        ) { filter in
            print("Применён фильтр: \(filter)")
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark — selected") {
    NavigationStack {
        ScheduleFilterView(
            filter: ScheduleFilter(
                departureTimeOptions: [.morning, .night],
                transfersOption: .hide
            )
        ) { filter in
            print("Применён фильтр: \(filter)")
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Light — empty") {
    NavigationStack {
        ScheduleFilterView(
            filter: ScheduleFilter()
        ) { filter in
            print("Применён фильтр: \(filter)")
        }
    }
    .preferredColorScheme(.light)
}
