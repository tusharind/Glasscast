import SwiftUI

struct HomeView: View {
    let userID: String
    let token: String
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var settings: UserSettings
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            // Background
            backgroundLayer

            VStack(spacing: 0) {
                // Search Bar
                searchBar
                    .padding(.horizontal)
                    .padding(.top, 10)

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(Color.theme(.primaryText))
                        .scaleEffect(1.5)
                    Spacer()
                } else if let weather = viewModel.weather {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header & Settings Button
                            HStack(alignment: .bottom) {
                                headerView(location: weather.location)

                                Button(action: {
                                    Task {
                                        await viewModel.saveToFavorites(
                                            userID: userID,
                                            token: token
                                        )
                                    }
                                }) {
                                    Image(
                                        systemName: viewModel
                                            .isCurrentCityFavorited
                                            ? "heart.fill" : "heart"
                                    )
                                    .font(.title2)
                                    .foregroundColor(
                                        viewModel.isCurrentCityFavorited
                                            ? Color.theme(.error)
                                            : Color.theme(.primaryText)
                                    )
                                    .padding(8)
                                    .background(
                                        Circle().fill(
                                            Color.theme(.primaryText).opacity(
                                                0.1
                                            )
                                        )
                                    )
                                }
                                .disabled(viewModel.isCurrentCityFavorited)

                                Spacer()
                                settingsButton
                            }

                            // Main Temp
                            mainWeatherCard(current: weather.current)

                            // Favorites Horizontal Scroll if any
                            if !viewModel.favorites.isEmpty {
                                favoritesRow
                            }

                            // Forecast Row
                            if let forecast = weather.forecast {
                                forecastRow(days: forecast.forecastday)
                            }

                            // Details Grid
                            detailsGrid(current: weather.current)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal)
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(Color.theme(.caution).opacity(0.8))

                        Text("Connection Issue")
                            .font(.headline)

                        Text(error)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        Button("Retry") {
                            Task {
                                await viewModel.loadWeather()
                                await viewModel.fetchFavorites(
                                    userID: userID,
                                    token: token
                                )
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .glassEffect(cornerRadius: 12)
                    }
                    .foregroundColor(Color.theme(.primaryText))
                    Spacer()
                }
            }
        }
        .task {
            // Load default city and favorites on appear
            await viewModel.loadWeather()
            await viewModel.fetchFavorites(userID: userID, token: token)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(authViewModel: authViewModel)
                .environmentObject(settings)
        }
        .alert(
            "Added to Favorites",
            isPresented: $viewModel.showSaveSuccessAlert
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(viewModel.lastSavedCity) has been added to your favorites.")
        }
    }

    private var favoritesRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Favorites")
                .font(.headline)
                .foregroundColor(Color.theme(.secondaryText))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.favorites) { favorite in
                        Button(action: {
                            viewModel.searchText = favorite.cityName
                            Task { await viewModel.loadWeather() }
                        }) {
                            Text(favorite.cityName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .glassEffect(cornerRadius: 10)
                                .foregroundColor(Color.theme(.primaryText))
                        }
                    }
                }
            }
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme(.secondaryText))

            TextField("", text: $viewModel.searchText)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text("Search city...").foregroundColor(
                        Color.theme(.primaryText).opacity(0.4)
                    )
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color.theme(.primaryText))
                .onSubmit {
                    Task { await viewModel.loadWeather() }
                }

            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme(.primaryText).opacity(0.4))
                }
            }
        }
        .padding()
        .glassEffect(cornerRadius: 15)
    }

    private var settingsButton: some View {
        Button(action: { showingSettings = true }) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 22))
                .foregroundColor(Color.theme(.primaryText))
                .frame(width: 48, height: 48)
                .background(
                    Circle().fill(Color.theme(.primaryText).opacity(0.15))
                )
                .overlay(
                    Circle().stroke(
                        Color.theme(.primaryText).opacity(0.3),
                        lineWidth: 1
                    )
                )
                .shadow(color: Color.theme(.background).opacity(0.1), radius: 5)
        }
    }

    private var backgroundLayer: some View {
        ZStack {
            Color.theme(.background).ignoresSafeArea()
            // Ambient orbs
            Circle().fill(Color.theme(.accentPrimary)).frame(width: 400).blur(
                radius: 80
            ).offset(x: -150, y: -350)
            Circle().fill(Color.theme(.accentSecondary)).frame(width: 350).blur(
                radius: 70
            ).offset(x: 180, y: 300)
            Circle().fill(Color.theme(.tintOrb).opacity(0.3)).frame(width: 300)
                .blur(radius: 90).offset(x: -50, y: 50)
        }
    }

    private func forecastRow(days: [ForecastDay]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5-Day Forecast")
                .font(.headline)
                .foregroundColor(Color.theme(.secondaryText))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(days) { day in
                        forecastCard(day: day)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func forecastCard(day: ForecastDay) -> some View {
        VStack(spacing: 8) {
            Text(day.date.toDate()?.dayOfWeek() ?? day.date)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Image(systemName: day.day.condition.symbolName)
                .font(.title2)
                .symbolRenderingMode(.multicolor)
            
            VStack(spacing: 2) {
                Text("\(Int(settings.isFahrenheit ? day.day.maxtempF : day.day.maxtempC))°")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("\(Int(settings.isFahrenheit ? day.day.mintempF : day.day.mintempC))°")
                    .font(.caption2)
                    .opacity(0.8)
            }
            .foregroundColor(.white)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(width: 80)
        .glassEffect(cornerRadius: 20)
    }
    
    private func headerView(location: Location) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(location.country)
                .font(.headline)
                .fontWeight(.medium)
                .opacity(0.6)
        }
        .foregroundColor(Color.theme(.primaryText))
    }

    private func mainWeatherCard(current: Current) -> some View {
        VStack(spacing: 8) {
            // Icon
            AsyncImage(url: URL(string: "https:\(current.condition.icon)")) {
                image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView().tint(Color.theme(.primaryText))
            }
            .frame(width: 100, height: 100)
            .shadow(color: Color.theme(.background).opacity(0.1), radius: 8)

            VStack(spacing: 0) {
                Text(
                    "\(Int(settings.isFahrenheit ? current.tempF : current.tempC))°"
                )
                .font(.system(size: 72, weight: .thin, design: .rounded))
                
                Text(current.condition.text)
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.9)
                
                Text("Feels like \(Int(settings.isFahrenheit ? current.feelslikeF : current.feelslikeC))°")
                    .font(.caption)
                    .opacity(0.6)
                    .padding(.top, 2)
            }
        }
        .foregroundColor(Color.theme(.primaryText))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .glassEffect(cornerRadius: 30)
    }

    private func detailsGrid(current: Current) -> some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 15
        ) {
            detailCell(
                icon: "wind",
                title: "Wind",
                value: "\(current.windKph) km/h"
            )
            detailCell(
                icon: "drop.fill",
                title: "Humidity",
                value: "\(current.humidity)%"
            )
            detailCell(
                icon: "eye.fill",
                title: "Visibility",
                value: "\(current.visKM) km"
            )
            detailCell(
                icon: "sun.max.fill",
                title: "UV Index",
                value: "\(current.uv)"
            )
        }
    }

    private func detailCell(icon: String, title: String, value: String)
        -> some View
    {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.caption)
            .opacity(0.7)

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .foregroundColor(Color.theme(.primaryText))
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect()
    }

}
