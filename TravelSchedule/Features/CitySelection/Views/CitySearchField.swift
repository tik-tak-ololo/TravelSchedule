//
//  CitySearchField.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import SwiftUI

struct CitySearchField: View {

    @Binding var text: String

    @FocusState.Binding var isFocused: Bool

    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.textFieldPlaceHolderColorIOS)

            TextField("Введите запрос", text: $text)
                .font(.system(size: 17))
                .foregroundStyle(.textPrimaryIOS)
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)

            if isFocused || !text.isEmpty {
                Button {
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.textFieldPlaceHolderColorIOS)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Очистить поиск")
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 36)
        .background(.searchFieldBackgroundIOS)
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }
}
