import SwiftUI
import Charts

struct AchievementChartView: View {
    @State private var actionRate: Double = 0
    @State private var skillRate: Double = 0
    @State private var mindRate: Double = 0

    @State private var selectedGenre = "勉強"
    let genres = ["勉強", "部活", "プライベート"]

    var body: some View {
        VStack {
            Text("📊 目標達成率グラフ")
                .font(.title2)
                .padding()

            // 🔽 ジャンル選択（プルダウン）
            Picker("ジャンルを選択", selection: $selectedGenre) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Chart {
                BarMark(
                    x: .value("目標", "行動"),
                    y: .value("達成率", actionRate)
                )
                BarMark(
                    x: .value("目標", "技術"),
                    y: .value("達成率", skillRate)
                )
                BarMark(
                    x: .value("目標", "心構え"),
                    y: .value("達成率", mindRate)
                )
            }
            .chartYScale(domain: 0...100)
            .frame(height: 300)
            .padding()

            Spacer()
        }
        .onAppear {
            calculateRates()
        }
        .onChange(of: selectedGenre) {
            calculateRates()
        }
    }

    func calculateRates() {
        let entries = EntryStorage.shared.load()
        let filtered = entries.filter { $0.goalGenre == selectedGenre }
        let total = Double(filtered.count)

        guard total > 0 else {
            actionRate = 0
            skillRate = 0
            mindRate = 0
            return
        }

        actionRate = (Double(filtered.filter { $0.actionAchieved }.count) / total) * 100
        skillRate = (Double(filtered.filter { $0.skillAchieved }.count) / total) * 100
        mindRate = (Double(filtered.filter { $0.mindAchieved }.count) / total) * 100
    }
}
