//
//  CreateReminderWidget.swift
//  CreateReminderWidget
//
//  Created by Yoan Dubuc on 2/28/24.
//

import WidgetKit
import SwiftUI

struct MainEntry: TimelineEntry {
    let placeholder: String
    let date: Date
}

struct CreateReminderWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Remind me to...")
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(entry.placeholder)
                .font(.body.weight(.regular))
                .foregroundColor(Color(hex: 0x444758))
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color(hex: 0x111216))
                .cornerRadius(8)
            
        } // VStack
        .widgetURL(URL(string: "widget://com.beamcove.perroquet.create-reminder")!)
        
    }
}

struct CreateReminderWidget: Widget {
    let kind: String = "CreateReminderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CreateReminderWidgetEntryView(entry: entry)
                    .containerBackground(Color(hex: 0x1c1d22), for: .widget)
            } else {
                CreateReminderWidgetEntryView(entry: entry)
                    .background(Color(hex: 0x1c1d22))
            }
        }
        .configurationDisplayName("Create Reminder")
        .description("Remind me to...")
        .supportedFamilies([.systemSmall])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MainEntry {
        MainEntry(placeholder: "Drink more water", date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (MainEntry) -> ()) {
        let entry = MainEntry(placeholder: "Drink more water", date: .now)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MainEntry>) -> ()) {
        let entry = MainEntry(placeholder: "Drink more water", date: .now)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

#Preview(as: .systemSmall) {
    CreateReminderWidget()
} timeline: {
    MainEntry(placeholder: "Drink more water", date: .now)
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
