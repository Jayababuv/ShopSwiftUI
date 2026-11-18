import SwiftUI

struct ProductListView: View {
    @EnvironmentObject private var store: ShoppingStore
    let subcategory: Subcategory
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var displayedProducts: [Product] {
        store.products.filter { $0.subcategoryId == subcategory.id }
    }

    var body: some View {
        ScrollView {
            if displayedProducts.isEmpty {
                ContentUnavailableView("No products yet", systemImage: "shippingbox", description: Text("There are no sample products in this category. Connect your API or choose another category."))
                    .padding(.top, 50)
            } else {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(displayedProducts) { product in
                        NavigationLink { ProductDetailView(product: product) } label: {
                            ProductCard(product: product)
                        }.buttonStyle(.plain)
                    }
                }.padding()
            }
        }
        .navigationTitle(subcategory.name)
        .task { await store.loadProducts(subcategoryId: subcategory.id) }
    }
}
