import SwiftUI

struct GoalHistoryView: View {
    @State private var goals: [GoalData] = []

    // 🔽 ジャンル切り替え用
    @State private var selectedGenre: String = "勉強"
    private let genres = ["勉強", "部活", "プライベート"]

    var body: some View {
        NavigationView {
            VStack {
                // 🔽 ジャンル選択
                Picker("ジャンルを選択", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                List(filteredGoals.reversed()) { goal in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("🗓 \(formattedDate(goal.date))")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text("🏁 長期：\(goal.longTerm)")
                        Text("⏳ 中期：\(goal.midTerm)")
                        Text("✅ 行動：\(goal.action)")
                        Text("🎯 技術：\(goal.skill)")
                        Text("🧠 心構え：\(goal.mind)")
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("過去の目標")
            .onAppear {
                goals = GoalStorage.shared.loadAll(for: selectedGenre)

            }
        }
    }

    // 🔍 選んだジャンルだけに絞って表示
    var filteredGoals: [GoalData] {
        goals.filter { $0.genre == selectedGenre }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
