import Foundation

struct FreelanceinvoiceItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var client: String
    var amount: Double
    var paid: Bool
}
