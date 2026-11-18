import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            Section("Your account") {
                Label("Orders", systemImage: "shippingbox")
                Label("Delivery addresses", systemImage: "mappin.and.ellipse")
                Label("Help & support", systemImage: "questionmark.circle")
            }
            Section {
                Text("ShopSwift demo app").foregroundStyle(.secondary)
                Text("Connect your authentication and order APIs to enable account features.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Profile")
    }
}
