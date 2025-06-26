import Foundation

// ジャンルを定義（追加）
enum GoalCategory: String, CaseIterable, Codable, Identifiable {
    case study = "勉強"
    case club = "部活"
    case privateLife = "プライベート"

    var id: String { self.rawValue }
}

// GoalData に category を追加（保存対象のジャンル）
struct GoalData: Codable, Identifiable, Hashable {
    var id = UUID()
    var genre: String         // ← 追加：ジャンル（例: 勉強、部活、プライベート）
    var longTerm: String      // 長期目標
    var midTerm: String       // 中期目標
    var action: String        // 行動目標
    var skill: String         // 技術目標
    var mind: String          // 心構え目標
    var date: Date = Date()   // 作成日時
}

