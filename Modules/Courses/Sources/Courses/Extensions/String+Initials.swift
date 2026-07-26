import Foundation

extension String {

    var initials: String {
        let words = self.split(separator: " ")
        let result = words.prefix(3).compactMap { $0.first.map(String.init) }
        return result.joined().uppercased()
    }
}

