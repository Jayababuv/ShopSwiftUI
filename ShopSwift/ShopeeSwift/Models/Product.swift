import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: String
    let subcategoryId: String
    let name: String
    let description: String
    let price: Double
    let originalPrice: Double?
    let rating: Double
    let imageURL: String?
    let specifications: [String: String]

    var discountPercent: Int {
        guard let originalPrice, originalPrice > price else { return 0 }
        return Int(((originalPrice - price) / originalPrice * 100).rounded())
    }

    static let samples: [Product] = [
        Product(id: "phone-1", subcategoryId: "mobiles", name: "Nova X Pro 5G", description: "Enjoy smooth performance, a vivid display and long battery life. A great everyday smartphone for work and entertainment.", price: 42999, originalPrice: 49999, rating: 4.4, imageURL: nil, specifications: ["Display": "6.7-inch AMOLED", "Storage": "256 GB", "Connectivity": "5G", "Warranty": "1 year"]),
        Product(id: "phone-2", subcategoryId: "mobiles", name: "Orbit Lite 5G", description: "A reliable smartphone with a bright screen, capable camera and dependable all-day battery.", price: 18999, originalPrice: 22999, rating: 4.2, imageURL: nil, specifications: ["Display": "6.5-inch LCD", "Storage": "128 GB", "Connectivity": "5G", "Warranty": "1 year"]),
        Product(id: "laptop-1", subcategoryId: "laptops", name: "AeroBook 14", description: "A lightweight laptop designed for productivity, study and everyday multitasking.", price: 58990, originalPrice: 64990, rating: 4.5, imageURL: nil, specifications: ["Display": "14-inch FHD", "Memory": "16 GB", "Storage": "512 GB SSD", "Warranty": "1 year"]),
        Product(id: "audio-1", subcategoryId: "audio", name: "Pulse Wireless Headphones", description: "Comfortable wireless headphones with rich sound and a foldable design.", price: 2499, originalPrice: 3999, rating: 4.1, imageURL: nil, specifications: ["Battery": "Up to 35 hours", "Connectivity": "Bluetooth", "Warranty": "1 year"]),
        Product(id: "fashion-1", subcategoryId: "mens-fashion", name: "Classic Everyday Sneakers", description: "Versatile casual sneakers with a cushioned footbed for daily wear.", price: 1799, originalPrice: 2499, rating: 4.0, imageURL: nil, specifications: ["Material": "Mesh and synthetic", "Closure": "Lace-up", "Warranty": "Manufacturer terms"]),
        Product(id: "home-1", subcategoryId: "kitchen", name: "Stainless Steel Cookware Set", description: "A practical cookware set for everyday home cooking.", price: 3299, originalPrice: 4499, rating: 4.3, imageURL: nil, specifications: ["Material": "Stainless steel", "Pieces": "5", "Care": "Hand wash recommended"]),
        Product(id: "home-2", subcategoryId: "utensils", name: "Stainless Steel Cookware Set2", description: "A practical cookware set for everyday home cooking.", price: 3999, originalPrice: 4999, rating: 4.1, imageURL: nil, specifications: ["Material": "Stainless steel", "Pieces": "8", "Care": "Hand wash recommended"])
    ]
}
