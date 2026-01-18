import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            // MARK: - Background
            backgroundLayer

            // MARK: - Integration
            // MARK: - Integration
            contentLayer

        }
        .animation(.easeInOut, value: viewModel.isAuthenticated)
    }

    // Gradient background to make glass pop
    private var backgroundLayer: some View {
        ZStack {
            Color.theme(.background).ignoresSafeArea()

            // Orbs for atmosphere
            Circle()
                .fill(Color.theme(.accentPrimary))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -100, y: -200)

            Circle()
                .fill(Color.theme(.tintOrb).opacity(0.5))
                .frame(width: 250, height: 250)
                .blur(radius: 50)
                .offset(x: 100, y: 150)
        }
    }

    private var contentLayer: some View {
        VStack(spacing: 30) {

            // Title
            VStack(spacing: 8) {
                Text("Glasscast")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.theme(.primaryText))
                    .shadow(
                        color: Color.theme(.primaryText).opacity(0.3),
                        radius: 10,
                        x: 0,
                        y: 0
                    )

                Text("Your weather, clearer.")
                    .font(.title3)
                    .foregroundStyle(Color.theme(.secondaryText))
            }
            .padding(.top, 50)

            // Glass Form
            VStack(spacing: 20) {

                // Toggle
                HStack {
                    Button(action: { viewModel.isSigningUp = false }) {
                        Text("Log In")
                            .fontWeight(
                                viewModel.isSigningUp ? .regular : .bold
                            )
                            .foregroundColor(
                                viewModel.isSigningUp
                                    ? Color.theme(.secondaryText)
                                    : Color.theme(.primaryText)
                            )
                    }

                    Text("/")
                        .foregroundColor(Color.theme(.primaryText).opacity(0.4))

                    Button(action: { viewModel.isSigningUp = true }) {
                        Text("Sign Up")
                            .fontWeight(
                                viewModel.isSigningUp ? .bold : .regular
                            )
                            .foregroundColor(
                                viewModel.isSigningUp
                                    ? Color.theme(.primaryText)
                                    : Color.theme(.secondaryText)
                            )
                    }
                }
                .font(.title3)
                .padding(.bottom, 10)

                // Fields
                glassTextField(
                    placeholder: "Email",
                    text: $viewModel.email,
                    icon: "envelope"
                )
                glassTextField(
                    placeholder: "Password",
                    text: $viewModel.password,
                    icon: "lock",
                    isSecure: true
                )

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(Color.theme(.error).opacity(0.8))
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }

                // Action Button
                Button(action: {
                    Task { await viewModel.action() }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(Color.theme(.primaryText))
                    } else {
                        Text(
                            viewModel.isSigningUp
                                ? "Create Account" : "Access Weather"
                        )
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    Color.theme(.primaryText).opacity(
                        viewModel.isLoading ? 0.1 : 0.2
                    )
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        Color.theme(.primaryText).opacity(0.3),
                        lineWidth: 1
                    )
                )
                .disabled(viewModel.isLoading)
            }
            .padding(30)
            .glassEffect()
            .padding(.horizontal)

            Spacer()
        }
    }

    private func glassTextField(
        placeholder: String,
        text: Binding<String>,
        icon: String,
        isSecure: Bool = false
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.theme(.secondaryText))

            if isSecure {
                SecureField("", text: text)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder).foregroundColor(
                            Color.theme(.primaryText).opacity(0.4)
                        )
                    }
            } else {
                TextField("", text: text)
                    .placeholder(when: text.wrappedValue.isEmpty) {
                        Text(placeholder).foregroundColor(
                            Color.theme(.primaryText).opacity(0.4)
                        )
                    }
            }
        }
        .padding()
        .background(Color.theme(.surfaceSecondary))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme(.primaryText).opacity(0.1), lineWidth: 1)
        )
        .foregroundColor(Color.theme(.primaryText))
    }
}
