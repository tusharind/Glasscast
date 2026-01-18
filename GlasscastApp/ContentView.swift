import Supabase
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @StateObject private var settings = UserSettings()

    var body: some View {
        Group {
            if viewModel.isAuthenticated, let session = viewModel.session,
                let user = session.user
            {
                HomeView(
                    userID: user.id,
                    token: session.accessToken ?? "",
                    authViewModel: viewModel
                )
                .environmentObject(settings)
                .transition(.opacity)
            } else {
                AuthView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.default, value: viewModel.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
