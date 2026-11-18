import SwiftUI

@main
struct ShopSwiftApp: App {
    @StateObject private var store = ShoppingStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
                .tint(.blue)
        }
    }
}
