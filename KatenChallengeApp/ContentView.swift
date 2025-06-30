import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FormView()
                .tabItem {
                    Label("記録", systemImage: "pencil")
                }

            DailyEntryListView()
                .tabItem {
                    Label("一覧", systemImage: "list.bullet")
                }

            GoalSummaryView()
                .tabItem {
                    Label("目標", systemImage: "target")
                }

            AchievementChartView()
                .tabItem {
                    Label("達成率", systemImage: "chart.bar.fill")
                }

            GoalHistoryView()
                .tabItem {
                    Label("履歴", systemImage: "clock")
                }
        }
    }
}
