//
//  CarrierDetailsView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

@MainActor
struct CarrierDetailsView: View {

    @State private var viewModel: CarrierDetailsViewModel

    init(
        carrier: Carrier,
        carrierProvider: any CarrierProviding = NetworkClient.shared
    ) {
        _viewModel = State(
            initialValue: CarrierDetailsViewModel(
                carrier: carrier,
                carrierProvider: carrierProvider
            )
        )
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColorIOS)
            .navigationTitle("Информация о перевозчике")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .task {
                await viewModel.loadCarrier()
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let errorScreenType = viewModel.errorScreenType {
            ErrorView(
                viewModel: ErrorViewModel(
                    errorType: errorScreenType
                )
            )
        } else {
            carrierDetails
        }
    }

    private var carrierDetails: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                logo
                    .padding(.bottom, 16)

                Text(viewModel.carrier.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 28)

                contactDetails
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
    }

    private var logo: some View {
        ZStack {
            Color.white

            logoContent
                .padding(.horizontal, 72)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 104)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    @ViewBuilder
    private var logoContent: some View {
        if let logoURL = viewModel.carrier.logoURL {
            AsyncImage(url: logoURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    fallbackLogo
                }
            }
        } else {
            fallbackLogo
        }
    }

    private var fallbackLogo: some View {
        Image(systemName: "tram.fill")
            .font(.system(size: 36))
            .foregroundStyle(.red)
    }

    private var contactDetails: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let email = viewModel.carrier.email,
               let emailURL = URL(string: "mailto:\(email)") {
                contactRow(
                    title: "E-mail",
                    value: email,
                    url: emailURL
                )
            }

            if let website = viewModel.carrier.website {
                contactRow(
                    title: "Сайт",
                    value: website.host() ?? website.absoluteString,
                    url: website
                )
            }

            if let phone = viewModel.carrier.phone,
               let phoneURL = viewModel.carrier.phoneURL {
                contactRow(
                    title: "Телефон",
                    value: phone,
                    url: phoneURL
                )
            }
        }
    }

    private func contactRow(
        title: String,
        value: String,
        url: URL
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 17))
                .foregroundStyle(.primary)

            Link(value, destination: url)
                .font(.system(size: 12))
                .foregroundStyle(.travelBlue)
        }
    }
}

#Preview("Light") {
    NavigationStack {
        CarrierDetailsView(carrier: .preview)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        CarrierDetailsView(carrier: .preview)
    }
    .preferredColorScheme(.dark)
}

private extension Carrier {
    static let preview = Carrier(
        title: "ОАО «РЖД»",
        website: URL(string: "https://www.rzd.ru"),
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71"
    )
}
