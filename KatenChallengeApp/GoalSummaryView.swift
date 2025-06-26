import SwiftUI

struct GoalSummaryView: View {
    @State private var selectedGenre = "勉強"
    let genres = ["勉強", "部活", "プライベート"]

    @State private var currentGoal: GoalData? = nil
    @State private var showSetting = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                // 🔽 ジャンル選択
                Picker("ジャンル", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom)

                // 🎯 現在の目標表示
                if let goal = currentGoal {
                    Group {
                        Text("🏁 長期目標：\(goal.longTerm)")
                        Text("⏳ 中期目標：\(goal.midTerm)")
                    }
                    .font(.headline)
                    .padding(.bottom)

                    Group {
                        Text("✅ 行動目標：\(goal.action)")
                        Text("🎯 技術目標：\(goal.skill)")
                        Text("🧠 心構え目標：\(goal.mind)")
                    }
                    .font(.body)

                    Text("📅 作成日：\(formattedDate(goal.date))")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                } else {
                    Text("このジャンルにはまだ目標が設定されていません。")
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }

                Spacer()

                Button("✏️ 新しい目標を設定する") {
                    showSetting = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()
            .navigationTitle("現在の目標")
            .onAppear {
                loadGoal()
            }
            .onChange(of: selectedGenre) { _ in
                loadGoal()
            }
            .sheet(isPresented: $showSetting, onDismiss: {
                loadGoal()
            }) {
                GoalSettingView()
            }
        }
    }

    func loadGoal() {
        currentGoal = GoalStorage.shared.loadLatest(for: selectedGenre)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
