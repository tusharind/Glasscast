import Combine
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSigningUp = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var session: AuthResponse?

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    var isAuthenticated: Bool {
        session?.accessToken != nil
    }

    func action() async {
        isLoading = true
        errorMessage = nil

        do {
            if isSigningUp {
                let response = try await authService.signUp(
                    email: email,
                    password: password
                )
                if response.accessToken == nil && response.user != nil {
                    errorMessage =
                        "Account created! Please verify your email to log in."
                    // Clear session to ensure we remain in 'unauthenticated' state until they login
                    session = nil
                } else {
                    session = response
                }
            } else {
                session = try await authService.signIn(
                    email: email,
                    password: password
                )
            }
        } catch {
            errorMessage = error.localizedDescription
            // If it's a specific network error, we could map it to a friendlier message
        }

        isLoading = false
    }

    func signOut() async {
        guard let token = session?.accessToken else {
            session = nil
            return
        }

        isLoading = true
        do {
            try await authService.signOut(accessToken: token)
            session = nil
        } catch {
            // Even if logout fails on server, clear local session
            session = nil
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
