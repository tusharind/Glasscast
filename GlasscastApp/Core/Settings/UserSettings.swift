import Combine
import SwiftUI

class UserSettings: ObservableObject {
    @Published var isFahrenheit: Bool {
        didSet {
            UserDefaults.standard.set(isFahrenheit, forKey: "isFahrenheit")
        }
    }

    init() {
        self.isFahrenheit = UserDefaults.standard.bool(forKey: "isFahrenheit")
    }
}
