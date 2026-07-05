//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 03.07.2026.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
//            testFetchStations()
//            testFetchCity()
//            testFetchCopyright()
//            testFetchAllStations()
//            testFetchSchedualBetweenStations()
            testFetchStationSchedule()
        }
    }
    
    func testFetchStations() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = Client(
                    // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                    serverURL: try Servers.Server1.url(),
                    // Указываем, какой транспорт использовать для отправки запросов
                    transport: URLSessionTransport(),
                    middlewares: [
                        AuthorizationMiddleware(apiKey: "aa8f79e9-8f33-44fc-a4d8-93c30dfc250e")
                    ]
                )
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = NearestStationsService(
                    client: client
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177, // Пример координат
                    lng: 30.319163, // Пример координат
                    distance: 50    // Пример дистанции
                )
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched stations: \(stations)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching stations: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    func testFetchCity() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = Client(
                    // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                    serverURL: try Servers.Server1.url(),
                    // Указываем, какой транспорт использовать для отправки запросов
                    transport: URLSessionTransport(),
                    middlewares: [
                        AuthorizationMiddleware(apiKey: "aa8f79e9-8f33-44fc-a4d8-93c30dfc250e")
                    ]
                )
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = NearestCityService(
                    client: client
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching city...")
                let city = try await service.getNearestCity(
                    lat: 59.864177, // Пример координат
                    lng: 30.319163, // Пример координат
                    distance: 50    // Пример дистанции
                )
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched city: \(city)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching city: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    func testFetchCopyright() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = Client(
                    // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                    serverURL: try Servers.Server1.url(),
                    // Указываем, какой транспорт использовать для отправки запросов
                    transport: URLSessionTransport(),
                    middlewares: [
                        AuthorizationMiddleware(apiKey: "aa8f79e9-8f33-44fc-a4d8-93c30dfc250e")
                    ]
                )
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = CopyrightService(
                    client: client
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching copyright...")
                let copyright = try await service.getCopyright()
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched copyright: \(copyright)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching copyright: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    func testFetchAllStations() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = Client(
                    // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                    serverURL: try Servers.Server1.url(),
                    // Указываем, какой транспорт использовать для отправки запросов
                    transport: URLSessionTransport(),
                    middlewares: [
                        AuthorizationMiddleware(apiKey: "aa8f79e9-8f33-44fc-a4d8-93c30dfc250e")
                    ]
                )
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = AllStationsService(
                    client: client
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching all stations...")
                let allStations = try await service.getAllStations()
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched all stations: \(allStations)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching all stations: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    func testFetchSchedualBetweenStations() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = Client(
                    // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                    serverURL: try Servers.Server1.url(),
                    // Указываем, какой транспорт использовать для отправки запросов
                    transport: URLSessionTransport(),
                    middlewares: [
                        AuthorizationMiddleware(apiKey: "aa8f79e9-8f33-44fc-a4d8-93c30dfc250e")
                    ]
                )
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = SegmentsService(
                    client: client
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching schedual between stations...")
                let schedualBetweenStations = try await service.getSchedualBetweenStations(from: "s9857050",
                                                                            to: "s9857047"
                )
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched schedual between stations: \(schedualBetweenStations)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching schedual between stations: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    func testFetchStationSchedule() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = Client(
                    // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                    serverURL: try Servers.Server1.url(),
                    // Указываем, какой транспорт использовать для отправки запросов
                    transport: URLSessionTransport(),
                    middlewares: [
                        AuthorizationMiddleware(apiKey: "aa8f79e9-8f33-44fc-a4d8-93c30dfc250e")
                    ]
                )
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = ScheduleService(
                    client: client
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching station schedule...")
                let stationSchedule = try await service.getStationSchedule(station: "s9600213")
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched station schedule: \(stationSchedule)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching station schedule: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
