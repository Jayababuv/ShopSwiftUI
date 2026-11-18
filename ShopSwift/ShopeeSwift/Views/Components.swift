import SwiftUI

struct ProductArtwork: View {
    let product: Product

    var body: some View {
        Group {
            if let urlString = product.imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFit().padding(8)
                    case .failure: placeholder
                    case .empty: ProgressView()
                    @unknown default: placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
    }

    private var placeholder: some View {
        VStack(spacing: 8) {
            Image(systemName: product.subcategoryId == "mobiles" ? "iphone.gen3" :
                    product.subcategoryId == "laptops" ? "laptopcomputer" :
                    product.subcategoryId == "audio" ? "headphones" :
                    product.subcategoryId == "kitchen" ? "fork.knife" : "shippingbox")
                .font(.system(size: 44)).foregroundStyle(.blue)
            Text(product.name).font(.caption2).multilineTextAlignment(.center).lineLimit(2)
                .foregroundStyle(.secondary)
        }.padding(10)
    }
}

struct ProductCard: View {
    @EnvironmentObject private var store: ShoppingStore
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProductArtwork(product: product).frame(height: 135)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .topTrailing) {
                    FavouriteButton(isFavourite: store.isFavourite(product)) {
                        store.toggleFavourite(product)
                    }.padding(6)
                }
            Text(product.name).font(.subheadline.weight(.medium)).lineLimit(2).foregroundStyle(.primary)
            Text(product.price.inr).font(.headline).foregroundStyle(.primary)
            HStack(spacing: 5) {
                Text("★ \(String(format: "%.1f", product.rating))")
                    .font(.caption.bold()).padding(.horizontal, 6).padding(.vertical, 3)
                    .background(Color.green.opacity(0.15), in: Capsule())
                if product.discountPercent > 0 {
                    Text("\(product.discountPercent)% off").font(.caption).foregroundStyle(.green)
                }
            }
            Button { store.addToCart(product) } label: {
                Label("Add to Cart", systemImage: "cart.badge.plus")
                    .font(.caption.bold()).frame(maxWidth: .infinity).padding(.vertical, 9)
            }.buttonStyle(.borderedProminent)
        }
        .padding(10)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            ProductArtwork(product: product).frame(width: 76, height: 78)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name).font(.headline).foregroundStyle(.primary)
                Text(product.price.inr).font(.subheadline.bold()).foregroundStyle(.primary)
                Text("★ \(String(format: "%.1f", product.rating))").font(.caption).foregroundStyle(.orange)
            }
            Spacer(minLength: 0)
        }.padding(.vertical, 4)
    }
}

struct FavouriteButton: View {
    let isFavourite: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isFavourite ? "heart.fill" : "heart")
                .font(.headline)
                .foregroundStyle(isFavourite ? .pink : .primary)
                .frame(width: 36, height: 36)
                .background(.regularMaterial, in: Circle())
        }.buttonStyle(.plain)
    }
}
