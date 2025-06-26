import Foundation

class GoalStorage {
    static let shared = GoalStorage()

    // 🔹 ジャンルごとのキーを生成
    private func key(for genre: String) -> String {
        return "goal_history_\(genre)"
    }

    // 🔹 目標を保存（ジャンルごとに履歴として追加）
    func save(_ newGoal: GoalData, for genre: String) {
        var current = loadAll(for: genre)
        current.append(newGoal)
        if let encoded = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(encoded, forKey: key(for: genre))
        }
    }

    // 🔹 履歴として全件を読み出す（ジャンル別）
    func loadAll(for genre: String) -> [GoalData] {
        if let data = UserDefaults.standard.data(forKey: key(for: genre)),
           let decoded = try? JSONDecoder().decode([GoalData].self, from: data) {
            return decoded
        }
        return []
    }

    // 🔹 最新の1件だけを取得（ジャンル別）
    func loadLatest(for genre: String) -> GoalData? {
        return loadAll(for: genre).last
    }

    // 🔹 全削除（ジャンル別）
    func clearAll(for genre: String) {
        UserDefaults.standard.removeObject(forKey: key(for: genre))
    }
}
