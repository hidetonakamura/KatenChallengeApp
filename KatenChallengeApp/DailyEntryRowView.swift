import SwiftUI

struct DailyEntryRowView: View {
    @Binding var entry: DailyEntry
    let index: Int
    let onTap: () -> Void

    var body: some View {
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
            if entry.isEdited {
                Text("✏️ 修正済み")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle()) // タップ範囲拡張
        .onTapGesture {
            onTap()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
