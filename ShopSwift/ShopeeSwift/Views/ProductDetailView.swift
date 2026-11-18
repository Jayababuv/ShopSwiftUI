import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject private var store: ShoppingStore
    let product: Product
    @State private var addedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ProductArtwork(product: product).frame(height: 280)
                    .overlay(alignment: .topTrailing) {
                        FavouriteButton(isFavourite: store.isFavourite(product)) {
                            store.toggleFavourite(product)
                        }.padding()
                    }

                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name).font(.title2.bold())
                    Label(String(format: "%.1f", product.rating) + " ★", systemImage: "star.fill")
                        .font(.subheadline).foregroundStyle(.orange)
                    HStack(spacing: 10) {
                        Text(product.price.inr).font(.title.bold())
                        if let original = product.originalPrice {
                            Text(original.inr).strikethrough().foregroundStyle(.secondary)
                            Text("\(product.discountPercent)% off").foregroundStyle(.green).font(.subheadline.bold())
                        }
                    }
                    Text(product.description).foregroundStyle(.secondary)
                    Label("Free delivery on orders above ₹999", systemImage: "truck.box")
                        .font(.subheadline).foregroundStyle(.green)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Specifications").font(.title3.bold())
                    ForEach(product.specifications.keys.sorted(), id: \.self) { key in
                        HStack(alignment: .top) {
                            Text(key).foregroundStyle(.secondary)
                            Spacer()
                            Text(product.specifications[key] ?? "").multilineTextAlignment(.trailing)
                        }
                        Divider()
                    }
                }

                HStack(spacing: 12) {
                    Button {
                        store.addToCart(product)
                        addedToCart = true
                    } label: {
                        Label(addedToCart ? "Added to Cart" : "Add to Cart", systemImage: addedToCart ? "checkmark" : "cart")
                            .frame(maxWidth: .infinity).padding()
                    }.buttonStyle(.bordered)
                    NavigationLink { CartView() } label: {
                        Text("Buy Now").frame(maxWidth: .infinity).padding()
                    }.buttonStyle(.borderedProminent)
                }
            }.padding()
        }
        .navigationTitle("Product details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
