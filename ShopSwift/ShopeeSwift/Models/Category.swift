import Foundation

struct ProductCategory: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageURL: String?
    var subcategories: [Subcategory] = []
}

struct Subcategory: Identifiable, Codable, Hashable {
    let id: String
    let categoryId: String
    let name: String
    let imageURL: String?
}
