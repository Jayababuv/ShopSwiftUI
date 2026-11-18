import Foundation

enum APIConfig {
    // Set this to your backend base URL, e.g. https://api.example.com
    static let baseURL: URL? = nil
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case badResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The API URL is invalid."
        case .badResponse: return "The server returned an unexpected response."
        case .decodingFailed: return "The server response could not be read."
        }
    }
}

protocol ShoppingAPI {
    func fetchCategories() async throws -> [ProductCategory]
    func fetchSubcategories(categoryId: String) async throws -> [Subcategory]
    func fetchProducts(subcategoryId: String) async throws -> [Product]
    func fetchProduct(id: String) async throws -> Product
    func createOrder(items: [CartLine], total: Double) async throws -> String
}

struct APIService: ShoppingAPI {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    private func get<T: Decodable>(_ path: String, as type: T.Type) async throws -> T {
        guard let baseURL = APIConfig.baseURL,
              let url = URL(string: path, relativeTo: baseURL) else { throw APIError.invalidURL }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badResponse
        }
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { throw APIError.decodingFailed }
    }

    func fetchCategories() async throws -> [ProductCategory] {
        try await get("categories", as: [ProductCategory].self)
    }

    func fetchSubcategories(categoryId: String) async throws -> [Subcategory] {
        try await get("categories/\(categoryId)/subcategories", as: [Subcategory].self)
    }

    func fetchProducts(subcategoryId: String) async throws -> [Product] {
        try await get("subcategories/\(subcategoryId)/products", as: [Product].self)
    }

    func fetchProduct(id: String) async throws -> Product {
        try await get("products/\(id)", as: Product.self)
    }

    func createOrder(items: [CartLine], total: Double) async throws -> String {
        // Replace with POST /orders when your backend is available.
        return "DEMO-\(UUID().uuidString.prefix(8).uppercased())"
    }
}
