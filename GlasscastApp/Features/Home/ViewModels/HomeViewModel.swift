import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = "Paris"
    @Published var favorites: [FavoriteCity] = []
    @Published var showSaveSuccessAlert = false
    @Published var lastSavedCity = ""

    private let weatherService: WeatherServiceProtocol
    private let databaseService: DatabaseServiceProtocol

    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        databaseService: DatabaseServiceProtocol = SupabaseDatabaseService()
    ) {
        self.weatherService = weatherService
        self.databaseService = databaseService
    }

    func loadWeather() async {
        isLoading = true
        errorMessage = nil

        do {
            weather = try await weatherService.getCurrentWeather(
                for: searchText
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func saveToFavorites(userID: String, token: String) async {
        guard let weather = weather else { return }

        let favorite = FavoriteCity(
            id: nil,
            userID: userID,
            cityName: weather.location.name,
            lat: weather.location.lat,
            lon: weather.location.lon,
            createdAt: nil
        )

        do {
            try await databaseService.saveFavoriteCity(favorite, token: token)
            self.lastSavedCity = weather.location.name
            self.showSaveSuccessAlert = true
            await fetchFavorites(userID: userID, token: token)
        } catch {
            errorMessage =
                "Failed to save favorite: \(error.localizedDescription)"
        }
    }

    func fetchFavorites(userID: String, token: String) async {
        do {
            favorites = try await databaseService.getFavoriteCities(
                userID: userID,
                token: token
            )
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }

    var isCurrentCityFavorited: Bool {
        guard let weather = weather else { return false }
        return favorites.contains(where: {
            $0.cityName.lowercased() == weather.location.name.lowercased()
        })
    }

}
