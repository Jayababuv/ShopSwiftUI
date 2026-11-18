import SwiftUI

struct SubcategoryView: View {
    @EnvironmentObject private var store: ShoppingStore
    let category: ProductCategory

    private var items: [Subcategory] {
        store.subcategories.filter { $0.categoryId == category.id }
    }

    var body: some View {
        List {
            Section("Explore \(category.name)") {
                ForEach(items) { subcategory in
                    NavigationLink {
                        ProductListView(subcategory: subcategory)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.title2).foregroundStyle(.blue)
                                .frame(width: 48, height: 48)
                                .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(subcategory.name).font(.headline)
                                Text("Browse products").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
                        }.padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .task { await store.loadSubcategories(categoryId: category.id) }
    }
}
