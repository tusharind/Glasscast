import SwiftUI

struct SettingsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject var settings: UserSettings
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Background
            backgroundLayer

            VStack(spacing: 25) {
                // Header
                HStack {
                    Text("Settings")
                        .font(
                            .system(size: 34, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(Color.theme(.primaryText))
                    Spacer()
                }
                .padding(.top, 40)

                VStack(spacing: 20) {
                    // Unit Section
                    settingRow(title: "Temperature Unit", icon: "thermometer") {
                        Picker("Unit", selection: $settings.isFahrenheit) {
                            Text("Celsius").tag(false)
                            Text("Fahrenheit").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }

                    Divider().background(Color.theme(.primaryText).opacity(0.1))

                    // User Info
                    if let user = authViewModel.session?.user {
                        settingRow(title: "Account", icon: "person.fill") {
                            Text(user.email ?? "User")
                                .font(.subheadline)
                                .foregroundColor(Color.theme(.secondaryText))
                        }
                    }
                }
                .padding(20)
                .glassEffect(cornerRadius: 25)

                Spacer()

                // Sign Out Button
                Button(action: {
                    Task {
                        await authViewModel.signOut()
                    }
                }) {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView().tint(Color.theme(.primaryText))
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Sign Out")
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(Color.theme(.primaryText))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme(.error).opacity(0.2))
                    .glassEffect(cornerRadius: 15)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
        }
    }

    private var backgroundLayer: some View {
        ZStack {
            Color.theme(.background).ignoresSafeArea()
            Circle().fill(Color.theme(.tintOrb).opacity(0.3)).frame(width: 400)
                .blur(radius: 80).offset(x: 150, y: -350)
            Circle().fill(Color.theme(.accentPrimary).opacity(0.2)).frame(
                width: 350
            ).blur(radius: 70).offset(x: -180, y: 300)
        }
    }

    private func settingRow<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.theme(.secondaryText))
                .frame(width: 30)

            Text(title)
                .foregroundColor(Color.theme(.primaryText))

            Spacer()

            content()
        }
    }
}
