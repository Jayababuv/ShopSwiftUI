import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var store: ShoppingStore
    @Environment(\.dismiss) private var dismiss
    @State private var fullName = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var paymentMethod = "Cash on Delivery"
    @State private var isPlacingOrder = false
    @State private var orderID: String?
    @State private var errorMessage: String?

    var body: some View {
        Form {
            if let orderID {
                Section {
                    ContentUnavailableView("Order placed!", systemImage: "checkmark.circle.fill", description: Text("Demo order number: \(orderID). No payment has been taken."))
                }
                Button("Continue Shopping") { dismiss() }
            } else {
                Section("Delivery details") {
                    TextField("Full name", text: $fullName)
                        .textContentType(.name)
                    TextField("Mobile number", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Full delivery address", text: $address, axis: .vertical)
                        .lineLimit(3...5)
                }
                Section("Payment method") {
                    Picker("Payment", selection: $paymentMethod) {
                        Text("Cash on Delivery").tag("Cash on Delivery")
                        Text("UPI (demo only)").tag("UPI (demo only)")
                        Text("Card (demo only)").tag("Card (demo only)")
                    }
                }
                Section("Order summary") {
                    HStack { Text("Items"); Spacer(); Text(store.subtotal.inr) }
                    HStack { Text("Delivery"); Spacer(); Text(store.deliveryFee == 0 ? "FREE" : store.deliveryFee.inr) }
                    HStack { Text("Total").bold(); Spacer(); Text(store.grandTotal.inr).bold() }
                }
                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                }
                Section {
                    Button {
                        Task { await placeOrder() }
                    } label: {
                        HStack {                                                                        
                            Spacer()
                            if isPlacingOrder { ProgressView() }
                            Text(isPlacingOrder ? "Placing order…" : "Place Order • \(store.grandTotal.inr)")
                            Spacer()
                        }
                    }
                    .disabled(isPlacingOrder || fullName.trimmingCharacters(in: .whitespaces).isEmpty ||
                              phone.filter(\.isNumber).count < 10 ||
                              address.trimmingCharacters(in: .whitespaces).isEmpty ||
                              store.cart.isEmpty)
                }
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }

    @MainActor
    private func placeOrder() async {
        isPlacingOrder = true
        defer { isPlacingOrder = false }
        do { orderID = try await store.placeDemoOrder() }
        catch { errorMessage = error.localizedDescription }
    }
}
