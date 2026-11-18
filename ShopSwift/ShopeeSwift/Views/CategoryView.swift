import SwiftUI

struct CategoryView: View {
    @EnvironmentObject private var store: ShoppingStore
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ShopSwift").font(.largeTitle.bold())
                        Text("Find something you'll love").foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "shippingbox.fill").font(.largeTitle).foregroundStyle(.blue)
                }
                .padding(.top, 8)

                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    Text("Search products").foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "slider.horizontal.3").foregroundStyle(.blue)
                }
                .padding(12).background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

                Text("Shop by category").font(.title2.bold())
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.categories) { category in
                        NavigationLink {
                            SubcategoryView(category: category)
                        } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14).fill(categoryColor(category.id).opacity(0.12))
                                    Image(systemName: categoryIcon(category.id))
                                        .font(.system(size: 38)).foregroundStyle(categoryColor(category.id))
                                }.frame(height: 100)
                                Text(category.name).font(.headline).foregroundStyle(.primary)
                                Text("Explore collection").font(.caption).foregroundStyle(.secondary)
                            }
                            .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                    }
                }
                Text("Popular products").font(.title2.bold())
                ForEach(Product.samples) { product in
                    NavigationLink { ProductDetailView(product: product) } label: {
                        ProductRow(product: product)
                    }.buttonStyle(.plain)
                }
            }.padding()
        }
        .navigationBarHidden(true)
        .task { await store.loadCategories() }
    }

    private func categoryIcon(_ id: String) -> String {
        switch id {
        case "electronics": return "iphone.gen3"
        case "fashion": return "tshirt"
        case "home": return "cup.and.saucer"
        default: return "sparkles"
        }
    }
    private func categoryColor(_ id: String) -> Color {
        switch id {
        case "electronics": return .blue
        case "fashion": return .purple
        case "home": return .orange
        default: return .pink
        }
    }
}
