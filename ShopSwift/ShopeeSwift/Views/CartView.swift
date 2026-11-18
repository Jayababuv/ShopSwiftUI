import SwiftUI

struct CartView: View {
    @EnvironmentObject private var store: ShoppingStore
    @State private var showCheckout = false

    var body: some View {
        Group {
            if store.cart.isEmpty {
                ContentUnavailableView("Your cart is empty", systemImage: "cart", description: Text("Add a few products and they will appear here."))
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(store.cart) { line in
                            HStack(alignment: .top, spacing: 12) {
                                ProductArtwork(product: line.product)
                                    .frame(width: 96, height: 104)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(line.product.name).font(.headline).lineLimit(2)
                                    Text(line.product.price.inr).font(.subheadline.bold())
                                    HStack(spacing: 0) {
                                        quantityButton("minus") { store.updateQuantity(for: line.product.id, to: line.quantity - 1) }
                                        Text("\(line.quantity)").font(.headline).frame(width: 42)
                                        quantityButton("plus") { store.updateQuantity(for: line.product.id, to: line.quantity + 1) }
                                        Spacer()
                                        Button("Remove", role: .destructive) { store.removeFromCart(line.product.id) }
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                        }

                        priceSummary

                        Button {
                            showCheckout = true
                        } label: {
                            Text("Proceed to Checkout")
                                .font(.headline).frame(maxWidth: .infinity).padding()
                        }.buttonStyle(.borderedProminent)
                    }.padding()
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total").font(.caption).foregroundStyle(.secondary)
                            Text(store.grandTotal.inr).font(.title3.bold())
                        }
                        Spacer()
                        Button("Checkout") { showCheckout = true }
                            .buttonStyle(.borderedProminent)
                    }.padding().background(.regularMaterial)
                }
            }
        }
        .navigationTitle("My Cart")
        .navigationDestination(isPresented: $showCheckout) { CheckoutView() }
    }

    private var priceSummary: some View {
        VStack(spacing: 10) {
            Text("Price Details").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
            summaryRow("Price (\(store.cartCount) items)", store.subtotal)
            summaryRow("Product savings", -store.discountTotal, green: true)
            HStack {
                Text("Delivery")
                Spacer()
                Text(store.deliveryFee == 0 ? "FREE" : store.deliveryFee.inr)
                    .foregroundStyle(store.deliveryFee == 0 ? .green : .primary)
            }
            Divider()
            HStack {
                Text("Total Amount").font(.headline)
                Spacer()
                Text(store.grandTotal.inr).font(.headline)
            }
            Text("You save \(store.discountTotal.inr) on this order")
                .font(.footnote).foregroundStyle(.green).frame(maxWidth: .infinity, alignment: .leading)
        }.padding().background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private func summaryRow(_ title: String, _ amount: Double, green: Bool = false) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(amount < 0 ? "-\((-amount).inr)" : amount.inr)
                .foregroundStyle(green ? .green : .primary)
        }.font(.subheadline)
    }

    private func quantityButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol).font(.caption.bold())
                .frame(width: 30, height: 30)
                .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
        }.buttonStyle(.plain)
    }
}
