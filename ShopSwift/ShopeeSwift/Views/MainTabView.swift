import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var store: ShoppingStore

    var body: some View {
        TabView {
            NavigationStack { CategoryView() }
                .tabItem { Label("Home", systemImage: "house") }

            NavigationStack { CategoryView() }
                .tabItem { Label("Categories", systemImage: "square.grid.2x2") }

            NavigationStack { FavouritesView() }
                .tabItem { Label("Favourites", systemImage: "heart") }

            NavigationStack { CartView() }
                .tabItem { Label("Cart", systemImage: "cart") }
                .badge(store.cartCount)

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
