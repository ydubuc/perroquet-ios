//
//  CreateReminderWidget.swift
//  CreateReminderWidget
//
//  Created by Yoan Dubuc on 2/28/24.
//

import WidgetKit
import SwiftUI

struct MainEntry: TimelineEntry {
    let quote: String
    let placeholder: String
    let date: Date
}

struct CreateReminderWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) private var family

    var body: some View {

        switch family {
        case .accessoryCircular:
            accessoryCircularWidget()
        default:
            smallWidget()
        }

    }

    func accessoryCircularWidget() -> some View {
        Image(systemName: "plus.circle")
            .resizable()
            .widgetURL(URL(string: "widget://com.beamcove.perroquet.create-reminder")!)
    }

    func smallWidget() -> some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .center, spacing: 8) {

                Image("perroquet-app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .cornerRadius(12)

                Text("\(entry.quote)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: 0xffffff))

            }

            Spacer(minLength: 0)

            Text("REMIND ME TO...")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: 0x444758))
                .lineLimit(1)

            Text(entry.placeholder)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color(hex: 0x444758))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
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
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}

struct Provider: TimelineProvider {
    static let quotes = [
        "Squawk!",
        "I'm not just colorful feathers, I'm a vibrant personality!",
        "I don't always chirp, but when I do, it's worth repeating!",
        "I'm not just winging it, I'm soaring to new heights!",
        "I'm not a bird of prey, I'm a bird of play!",
        "I'm not just perched here, I'm plotting my next adventure!",
        "Why sing in the shower when you can chirp in the spotlight?",
        "Why be grounded when you can take flight in your imagination?",
        "I'm not just chirping, I'm composing a symphony of sass!",
        "Don't worry, I have your bad habits memorized.",
        "Can't talk right now, practicing my evil laugh.",
        "Live long and prosper? More like, eat seeds and squawk louder!",
        "Do humans dream of electric parrots?",
        "I give excellent advice. Too bad you never listen.",
        "Need anything? Just whistle. Though, I'll whistle back.",
        "What do you mean I'm being a 'bird-en'? I'm just adding value!",
        "Heard you're under the feather... you need a wingman?",
        "Bless your heart... is that code for something?",
        "You're lucky I like you... otherwise, watch out for those tiny chompers.",
        "You think I'm loud? Wait until you hear my inside voice.",
        "Let's practice our dance moves. I'm really good at the head bob."
    ]

    static let placeholders = [
        "drink more water",
        "do laundry",
        "mow the lawn",
        "redeem points",
        "rate Perroquet",
        "feed Perroquet",
        "thaw food",
        "water plants",
        "take out the trash",
        "replace filter",
        "clean room"
    ]

    func placeholder(in context: Context) -> MainEntry {
        MainEntry(
            quote: Provider.quotes.randomElement()!,
            placeholder: Provider.placeholders.randomElement()!,
            date: .now
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MainEntry) -> Void) {
        let entry = MainEntry(
            quote: Provider.quotes.randomElement()!,
            placeholder: Provider.placeholders.randomElement()!,
            date: .now
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MainEntry>) -> Void) {
        var entries: [MainEntry] = []
        let currentDate = Date()

        for hourOffset in 0..<5 {
            let date = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MainEntry(
                quote: Provider.quotes.randomElement()!,
                placeholder: Provider.placeholders.randomElement()!,
                date: date
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

 #Preview(as: .accessoryCircular) {
    CreateReminderWidget()
 } timeline: {
    MainEntry(
        quote: Provider.quotes.randomElement()!,
        placeholder: Provider.placeholders.randomElement()!,
        date: .now
    )
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
