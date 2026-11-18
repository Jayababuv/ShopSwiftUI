import Foundation
import Combine

struct CartLine: Identifiable, Codable, Hashable {
    var id: String { product.id }
    let product: Product
    var quantity: Int
    var lineTotal: Double { product.price * Double(quantity) }
}

@MainActor
final class ShoppingStore: ObservableObject {
    @Published private(set) var categories: [ProductCategory] = []
    @Published private(set) var subcategories: [Subcategory] = []
    @Published private(set) var products: [Product] = Product.samples
    @Published private(set) var cart: [CartLine] = []
    @Published private(set) var favouriteIDs: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: ShoppingAPI
    private let defaults = UserDefaults.standard
    private let cartKey = "shopswift.cart.v1"
    private let favouritesKey = "shopswift.favourites.v1"

    init(api: ShoppingAPI = APIService()) {
        self.api = api
        restoreLocalState()
        loadSampleCatalog()
    }

    var cartCount: Int { cart.reduce(0) { $0 + $1.quantity } }
    var subtotal: Double { cart.reduce(0) { $0 + $1.lineTotal } }
    var deliveryFee: Double { cart.isEmpty || subtotal >= 999 ? 0 : 49 }
    var discountTotal: Double { cart.reduce(0) { total, line in
        guard let original = line.product.originalPrice else { return total }
        return total + max(0, original - line.product.price) * Double(line.quantity)
    }}
    var grandTotal: Double { subtotal + deliveryFee }

    func loadCategories() async {
        guard APIConfig.baseURL != nil else { return }
        isLoading = true
        defer { isLoading = false }
        do { categories = try await api.fetchCategories() }
        catch { errorMessage = error.localizedDescription }
    }

    func loadSubcategories(categoryId: String) async {
        guard APIConfig.baseURL != nil else {
            subcategories = Self.sampleSubcategories.filter { $0.categoryId == categoryId }
            return
        }
        do { subcategories = try await api.fetchSubcategories(categoryId: categoryId) }
        catch { errorMessage = error.localizedDescription }
    }

    func loadProducts(subcategoryId: String) async {
        guard APIConfig.baseURL != nil else {
            products = Product.samples.filter { $0.subcategoryId == subcategoryId }
            return
        }
        do { products = try await api.fetchProducts(subcategoryId: subcategoryId) }
        catch { errorMessage = error.localizedDescription }
    }

    func addToCart(_ product: Product) {
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartLine(product: product, quantity: 1))
        }
        persistCart()
    }

    func updateQuantity(for productID: String, to quantity: Int) {
        guard let index = cart.firstIndex(where: { $0.product.id == productID }) else { return }
        if quantity <= 0 { cart.remove(at: index) }
        else { cart[index].quantity = quantity }
        persistCart()
    }

    func removeFromCart(_ productID: String) {
        cart.removeAll { $0.product.id == productID }
        persistCart()
    }

    func toggleFavourite(_ product: Product) {
        if favouriteIDs.contains(product.id) { favouriteIDs.remove(product.id) }
        else { favouriteIDs.insert(product.id) }
        defaults.set(Array(favouriteIDs), forKey: favouritesKey)
    }

    func isFavourite(_ product: Product) -> Bool { favouriteIDs.contains(product.id) }

    var favouriteProducts: [Product] {
        Product.samples.filter { favouriteIDs.contains($0.id) }
            + products.filter { favouriteIDs.contains($0.id) && !Product.samples.contains($0) }
    }

    func placeDemoOrder() async throws -> String {
        let orderID = try await api.createOrder(items: cart, total: grandTotal)
        cart.removeAll()
        persistCart()
        return orderID
    }

    private func loadSampleCatalog() {
        categories = [
            ProductCategory(id: "electronics", name: "Electronics", imageURL: nil, subcategories: []),
            ProductCategory(id: "fashion", name: "Fashion", imageURL: nil, subcategories: []),
            ProductCategory(id: "home", name: "Home & Kitchen", imageURL: nil, subcategories: []),
            ProductCategory(id: "beauty", name: "Beauty", imageURL: nil, subcategories: [])
        ]
        subcategories = Self.sampleSubcategories
    }

    static let sampleSubcategories: [Subcategory] = [
        Subcategory(id: "mobiles", categoryId: "electronics", name: "Mobiles", imageURL: nil),
        Subcategory(id: "laptops", categoryId: "electronics", name: "Laptops", imageURL: nil),
        Subcategory(id: "audio", categoryId: "electronics", name: "Headphones & Audio", imageURL: nil),
        Subcategory(id: "mens-fashion", categoryId: "fashion", name: "Men's Fashion", imageURL: nil),
        Subcategory(id: "kitchen", categoryId: "home", name: "Kitchen", imageURL: nil),
        Subcategory(id: "utensils", categoryId: "home", name: "Utensils", imageURL: nil),
        Subcategory(id: "beauty-care", categoryId: "beauty", name: "Beauty Care", imageURL: nil)
    ]

    private func restoreLocalState() {
        if let data = defaults.data(forKey: cartKey),
           let saved = try? JSONDecoder().decode([CartLine].self, from: data) { cart = saved }
        if let saved = defaults.stringArray(forKey: favouritesKey) { favouriteIDs = Set(saved) }
    }

    private func persistCart() {
        if let data = try? JSONEncoder().encode(cart) { defaults.set(data, forKey: cartKey) }
    }
}
