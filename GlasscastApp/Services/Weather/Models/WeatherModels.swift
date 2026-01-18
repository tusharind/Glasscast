import Foundation

// MARK: - Weather Response
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast?
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {
    var id: String { date }
    let date: String
    let dateEpoch: Int
    let day: Day
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
    }
}

struct Day: Codable {
    let maxtempC, maxtempF: Double
    let mintempC, mintempF: Double
    let avgtempC, avgtempF: Double
    let maxwindMph, maxwindKph: Double
    let totalprecipMm, totalprecipIn: Double
    let avgvisKm, avgvisMiles: Double
    let avghumidity: Double
    let dailyWillItRain, dailyChanceOfRain: Int
    let dailyWillItSnow, dailyChanceOfSnow: Int
    let condition: Condition
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case avgvisKm = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

// MARK: - Current Weather
struct Current: Codable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC: Double
    let tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMB: Double
    let pressureIn: Double
    let precipMm, precipIn: Double
    let humidity, cloud: Int
    let feelslikeC, feelslikeF: Double
    let windchillC, windchillF: Double?
    let heatindexC, heatindexF: Double?
    let dewpointC, dewpointF: Double?
    let visKM, visMiles: Double
    let uv: Double
    let gustMph, gustKph: Double?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

// MARK: - Extensions
extension Condition {
    var symbolName: String {
        switch code {
        case 1000: return "sun.max.fill" // Sunny
        case 1003: return "cloud.sun.fill" // Partly cloudy
        case 1006, 1009: return "cloud.fill" // Cloudy/Overcast
        case 1030, 1135, 1147: return "cloud.fog.fill" // Mist/Fog
        case 1063, 1180, 1183, 1186, 1189, 1192, 1195, 1240, 1243: return "cloud.rain.fill" // Rain
        case 1066, 1114, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258: return "cloud.snow.fill" // Snow
        case 1069, 1072, 1168, 1171, 1204, 1207, 1237, 1249, 1252, 1261, 1264: return "cloud.sleet.fill" // Sleet
        case 1087, 1273, 1276, 1279, 1282: return "cloud.bolt.rain.fill" // Thunderstorm
        default: return "cloud.sun.fill"
        }
    }
}

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

extension Date {
    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
}
