import SwiftUI

struct GoalSettingView: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedGenre = "勉強"
    let genres = ["勉強", "部活", "プライベート"]

    @State private var longTerm = ""
    @State private var midTerm = ""
    @State private var action = ""
    @State private var skill = ""
    @State private var mind = ""

    @State private var longTermDate = Date()
    @State private var midTermDate = Date()

    var body: some View {
        NavigationView {
            Form {
                // 🔽 ジャンル選択
                Section(header: Text("ジャンルを選ぼう")) {
                    Picker("ジャンル", selection: $selectedGenre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // 🏁 長期目標
                Section(header: Text("🏁 長期目標")) {
                    TextField("例：ソロ演奏ができるようになる", text: $longTerm)

                    DatePicker("目標達成日", selection: $longTermDate, displayedComponents: .date)

                    Text("目標：\(formattedDate(longTermDate))までに達成する")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // ⏳ 中期目標
                Section(header: Text("⏳ 中期目標")) {
                    TextField("例：チューバが吹けるようにする", text: $midTerm)

                    DatePicker("目標達成日", selection: $midTermDate, displayedComponents: .date)

                    Text("目標：\(formattedDate(midTermDate))までに達成する")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // 💡 ヒント
                Section {
                    Text("💡まずは「中期目標」を達成するために、どんなことができるかを考えてみましょう。")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                // 🎯 今週の目標
                Section(header: Text("🎯 今週の目標を入力しよう")) {
                    TextField("✅ 行動目標", text: $action)
                    TextField("🎯 技術目標", text: $skill)
                    TextField("🧠 心構え目標", text: $mind)
                }

                // 保存ボタン
                Section {
                    Button("保存する") {
                        let newGoal = GoalData(
                            genre: selectedGenre,
                            longTerm: "\(longTerm)（\(formattedDate(longTermDate))までに）",
                            midTerm: "\(midTerm)（\(formattedDate(midTermDate))までに）",
                            action: action,
                            skill: skill,
                            mind: mind
                        )
                        GoalStorage.shared.save(newGoal, for: selectedGenre)
                        dismiss()
                    }
                    .disabled(longTerm.isEmpty || midTerm.isEmpty)
                }
            }
            .navigationTitle("目標を設定する")
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
}
