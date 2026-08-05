import SwiftUI

struct UserAgreementView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heading(Self.title)

                bodyText(Self.introduction)
                    .padding(.top, 8)

                bodyText("Российская Федерация, город Москва")
                    .padding(.top, 20)

                ForEach(Self.sections) { section in
                    heading(section.title)
                        .padding(.top, 24)

                    bodyText(section.text)
                        .padding(.top, 8)
                }
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
        .background(Color.backgroundColorIOS)
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private func heading(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.textPrimaryIOS)
    }

    private func bodyText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17))
            .foregroundStyle(.textPrimaryIOS)
    }
}

private extension UserAgreementView {

    struct Section: Identifiable {
        let title: String
        let text: String

        var id: String { title }
    }

    static let title = """
    Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц
    """

    static let introduction = """
    Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer
    """

    static let sections = [
        Section(
            title: "1. ТЕРМИНЫ",
            text: """
            Понятия, используемые в Оферте, означают следующее:

            Авторизованные адреса — адреса электронной почты каждой из Сторон. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.

            Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения.

            Исполнитель — организация, оказывающая образовательные услуги в соответствии с условиями Оферты.

            Личный кабинет — закрытая часть Сервиса, доступная Студенту после авторизации.

            Оферта — настоящий документ, содержащий предложение заключить договор об оказании образовательных услуг.
            """
        ),
        Section(
            title: "2. ПРЕДМЕТ ОФЕРТЫ",
            text: """
            Исполнитель обязуется оказать Студенту образовательные услуги, а Студент обязуется соблюдать условия обучения и произвести оплату в порядке и сроки, предусмотренные Офертой.

            Содержание, сроки и формат обучения определяются выбранной программой и информацией, размещенной на Сервисе.
            """
        ),
        Section(
            title: "3. ПРАВА И ОБЯЗАННОСТИ СТОРОН",
            text: "Студент обязуется предоставлять достоверные сведения, самостоятельно выполнять задания и соблюдать правила использования Сервиса. Исполнитель предоставляет доступ к учебным материалам и организует образовательный процесс."
        ),
        Section(
            title: "4. ЗАКЛЮЧИТЕЛЬНЫЕ ПОЛОЖЕНИЯ",
            text: "К отношениям Сторон применяется законодательство Российской Федерации. Продолжая использовать Сервис, Студент подтверждает, что ознакомился с условиями Оферты и принимает их."
        )
    ]
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
