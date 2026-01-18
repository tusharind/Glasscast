import Foundation

struct FavoriteCity: Codable, Identifiable {
    let id: Int?
    let userID: String
    let cityName: String
    let lat: Double
    let lon: Double
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cityName = "city_name"
        case lat = "latitude"
        case lon = "longitude"
        case createdAt = "created_at"
    }
}
