import SwiftUI

struct DailyEntryListView: View {
    @State private var entries: [DailyEntry] = []
    @State private var selectedEntry: DailyEntry? = nil
    @State private var selectedGenre: String = "勉強"
    let genres = ["勉強", "部活", "プライベート"]

    var body: some View {
        NavigationStack {
            VStack {
                // 🔽 ジャンル選択
                Picker("ジャンルを選択", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                List {
                    ForEach(filteredEntries.indices, id: \.self) { index in
                        let entry = filteredEntries[index]

                        VStack(alignment: .leading, spacing: 6) {
                            Text("🗓 \(formattedDate(entry.date))")
                                .font(.caption)
                                .foregroundColor(.gray)

                            Text("🌟 \(entry.didWell)")
                                .font(.headline)

                            if !entry.effortNote.isEmpty {
                                Text("💪 \(entry.effortNote)")
                                    .font(.subheadline)
                            }

                            Text("🚀 明日: \(entry.tomorrowGoal)")
                                .font(.subheadline)

                            HStack {
                                ForEach(0..<entry.stars, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }

                            HStack {
                                Text("📊 目標達成：")
                                Text(entry.actionAchieved ? "✅" : "❌")
                                Text(entry.skillAchieved ? "✅" : "❌")
                                Text(entry.mindAchieved ? "✅" : "❌")
                            }
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedEntry = entry
                        }
                    }
                    .onDelete(perform: deleteEntry)
                }
            }
            .navigationTitle("過去の記録")
            .onAppear {
                entries = EntryStorage.shared.load()
            }
            .navigationDestination(item: $selectedEntry) { entry in
                if let i = entries.firstIndex(where: { $0.id == entry.id }) {
                    EditEntryView(entry: $entries[i])
                }
            }
        }
    }

    var filteredEntries: [DailyEntry] {
        entries.filter { $0.goalGenre == selectedGenre }
    }

    func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            entries.remove(at: index)
        }
        EntryStorage.shared.saveAll(entries)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
