//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

// 1. Импортируем библиотеки:
import OpenAPIRuntime
import OpenAPIURLSession

// 2. Улучшаем читаемость кода — необязательный шаг
// Создаём псевдоним (typealias) для сгенерированного типа Stations.
// Полное имя Components.Schemas.Stations соответствует пути в openapi.yaml:
// components → schemas → Stations
typealias Copyright = Components.Schemas.CopyrightResponse

// Определяем протокол для нашего сервиса (хорошая практика для тестирования и гибкости)
protocol CopyrightServiceProtocol {
  // Функция для получения копирайта, асинхронная и может выбросить ошибку
  func getCopyright() async throws -> Copyright
}

// Конкретная реализация сервиса
final class CopyrightService: CopyrightServiceProtocol {
  // Хранит экземпляр сгенерированного клиента
  private let client: Client
  
  init(client: Client) {
    self.client = client
  }
  
  func getCopyright() async throws -> Copyright {
    // Вызываем функцию getNearestStations на ЭКЗЕМПЛЯРЕ сгенерированного клиента.
    // Имя функции и параметры 'query' напрямую соответствуют операции
    // 'getNearestStations' и её параметрам в openapi.yaml
      let response = try await client.getCopyright(
          query: .init(
            format: .json
          )

      )
    // response.ok: Доступ к успешному ответу
    // .body: Получаем тело ответа
    // .json: Получаем объект из JSON в ожидаемом типе NearestStations
    return try response.ok.body.json
  }
}
