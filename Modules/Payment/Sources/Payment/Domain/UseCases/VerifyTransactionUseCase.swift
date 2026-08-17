import Foundation

public class VerifyTransactionUseCase {
    private let repository: PaymentRepositoryProtocol

    public init(repository: PaymentRepositoryProtocol = PaymentRepository()) {
        self.repository = repository
    }

    public func execute(reference: String) async throws -> Bool {
        try await repository.verifyTransaction(reference: reference)
    }
}
