import Foundation

struct DailyEntry: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var didWell: String
    var effortNote: String
    var tomorrowGoal: String
    var stars: Int
    var sharedWithParent: Bool
    var isEdited: Bool = false
    var date: Date = Date()

    // 🕒 比較用（修正前の保存）
    var originalDidWell: String? = nil
    var originalEffortNote: String? = nil
    var originalTomorrowGoal: String? = nil

    // 達成状況
    var actionAchieved: Bool
    var skillAchieved: Bool
    var mindAchieved: Bool

    // 📌 追加：ジャンル（例：勉強・部活・プライベートなど）
    var goalGenre: String
}

// 👇 このように、構造体の「外」に書いてください！
class EntryStorage {
    static let shared = EntryStorage()
    private let key = "daily_entries"

    func save(_ entry: DailyEntry) {
        var current = load()
        current.append(entry)
        if let encoded = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func saveAll(_ entries: [DailyEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func load() -> [DailyEntry] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([DailyEntry].self, from: data) {
            return decoded
        }
        return []
    }

    func update(_ updatedEntry: DailyEntry) {
        var current = load()
        if let index = current.firstIndex(where: { $0.id == updatedEntry.id }) {
            current[index] = updatedEntry
            if let encoded = try? JSONEncoder().encode(current) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
