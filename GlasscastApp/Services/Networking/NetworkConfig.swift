import Foundation

struct NetworkConfig {
    let baseURL: String
    let headers: [String: String]
    let timeout: TimeInterval

    static let weatherAPI = NetworkConfig(
        baseURL: "https://api.weatherapi.com/v1",
        headers: [:],
        timeout: 30
    )

    static let supabase = NetworkConfig(
        baseURL: AppConfig.supabaseURL,
        headers: [
            "apikey": AppConfig.supabaseAnonKey,
            "Authorization": "Bearer \(AppConfig.supabaseAnonKey)"
        ],
        timeout: 30
    )

    static let weatherAPIKey = Secrets.weatherAPIKey
}
