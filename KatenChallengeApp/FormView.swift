import SwiftUI

struct FormView: View {
    @State private var didWell = ""
    @State private var effortNote = ""
    @State private var tomorrowGoal = ""
    @State private var stars = 0
    @State private var shareWithParent = false

    @State private var selectedGenre = "勉強"
    let genres = ["勉強", "部活", "プライベート"]

    @State private var currentGoal: GoalData? = nil

    @State private var actionAchieved = false
    @State private var skillAchieved = false
    @State private var mindAchieved = false

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

                // 🎯 目標表示（ジャンルごとに変わる）
                if let goal = currentGoal {
                    Section(header: Text("🎯 今週の短期目標")) {
                        Text("✅ 行動: \(goal.action)")
                        Text("🎯 技術: \(goal.skill)")
                        Text("🧠 心構え: \(goal.mind)")
                    }
                }

                Section(header: Text("🌟 今日の『できた！』")) {
                    TextEditor(text: $didWell)
                        .frame(height: 100) // お好みで高さ調整
                }

                Section(header: Text("💪 頑張ったポイント（任意）")) {
                    TextEditor(text: $effortNote)
                        .frame(height: 100)
                }

                Section(header: Text("🚀 明日のチャレンジ")) {
                    TextEditor(text: $tomorrowGoal)
                        .frame(height: 100)
                }

                Section(header: Text("⭐ 自分にスタンプをあげよう")) {
                    HStack {
                        ForEach(1...3, id: \.self) { num in
                            Image(systemName: stars >= num ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    stars = num
                                }
                        }
                    }
                }

                Section {
                    Toggle(isOn: $shareWithParent) {
                        Text("👨‍👩‍👧 親に共有する")
                    }
                }

                Section(header: Text("📊 目標の達成チェック")) {
                    Toggle("✅ 行動目標 達成できた", isOn: $actionAchieved)
                    Toggle("🎯 技術目標 達成できた", isOn: $skillAchieved)
                    Toggle("🧠 心構え目標 達成できた", isOn: $mindAchieved)
                }

                Section {
                    Button("記録を保存") {
                        let newEntry = DailyEntry(
                            didWell: didWell,
                            effortNote: effortNote,
                            tomorrowGoal: tomorrowGoal,
                            stars: stars,
                            sharedWithParent: shareWithParent,
                            actionAchieved: actionAchieved,
                            skillAchieved: skillAchieved,
                            mindAchieved: mindAchieved,
                            goalGenre: selectedGenre
                        )
                        EntryStorage.shared.save(newEntry)

                        // 入力リセット
                        didWell = ""
                        effortNote = ""
                        tomorrowGoal = ""
                        stars = 0
                        shareWithParent = false
                        actionAchieved = false
                        skillAchieved = false
                        mindAchieved = false

                        // 🔄 目標の再読み込み（表示更新）
                        loadGoal()
                    }

                }
            }
            .navigationTitle("1日チャレンジ記録")
            .onAppear(perform: loadGoal)
            .onChange(of: selectedGenre) {
                loadGoal()
            }


        }
    }

    func loadGoal() {
        if let latest = GoalStorage.shared.loadLatest(for: selectedGenre) {
            currentGoal = latest
        } else {
            currentGoal = nil
        }
    }
}
