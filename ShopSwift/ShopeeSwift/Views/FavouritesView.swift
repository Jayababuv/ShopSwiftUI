import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var store: ShoppingStore

    var body: some View {
        Group {
            if store.favouriteProducts.isEmpty {
                ContentUnavailableView("No favourites yet", systemImage: "heart", description: Text("Tap the heart on a product to save it here."))
            } else {
                List {
                    ForEach(store.favouriteProducts) { product in
                        HStack(spacing: 12) {
                            NavigationLink { ProductDetailView(product: product) } label: {
                                ProductRow(product: product)
                            }.buttonStyle(.plain)
                            Button {
                                store.addToCart(product)
                            } label: {
                                Image(systemName: "cart.badge.plus").font(.title3)
                            }.buttonStyle(.borderless)
                            Button {
                                store.toggleFavourite(product)
                            } label: {
                                Image(systemName: "heart.fill").foregroundStyle(.pink)
                            }.buttonStyle(.borderless)
                        }
                    }
                }.listStyle(.plain)
            }
        }
        .navigationTitle("Favourites")
    }
}
