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
        baseURL: Secrets.supabaseURL,
        headers: [
            "apikey": Secrets.supabaseAnonKey,
            "Authorization": "Bearer \(Secrets.supabaseAnonKey)"
        ],
        timeout: 30
    )

    static let weatherAPIKey = Secrets.weatherAPIKey
}
