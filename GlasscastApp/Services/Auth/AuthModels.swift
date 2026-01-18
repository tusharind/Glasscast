import Foundation

// MARK: - Auth Response
struct AuthResponse: Codable {
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let refreshToken: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case user
    }
}

struct User: Codable {
    let id: String
    let aud: String
    let role: String
    let email: String?
    let emailConfirmedAt: String?
    let confirmedAt: String?
    let lastSignInAt: String?

    enum CodingKeys: String, CodingKey {
        case id, aud, role, email
        case emailConfirmedAt = "email_confirmed_at"
        case confirmedAt = "confirmed_at"
        case lastSignInAt = "last_sign_in_at"
    }
}

struct Session: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String?
    let user: User
}

// MARK: - Auth Requests

struct AuthRequest: Codable {
    let email: String
    let password: String
    let data: [String: String]?

    init(email: String, password: String, data: [String: String]? = nil) {
        self.email = email
        self.password = password
        self.data = data
    }
}
