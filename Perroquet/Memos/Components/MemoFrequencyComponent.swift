//
//  MemoFrequencyComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/20/24.
//

import SwiftUI

struct MemoFrequencyComponent: View {
    @Binding var frequency: String
    let theme: Theme

    var body: some View {
        Menu {
            Button {
                frequency = ""
            } label: {
                Text("Once")
            }

            Button {
                frequency = Memo.Frequency.hourly.rawValue
            } label: {
                Text("Hourly")
            }

            Button {
                frequency = Memo.Frequency.daily.rawValue
            } label: {
                Text("Daily")
            }

            Button {
                frequency = Memo.Frequency.weekly.rawValue
            } label: {
                Text("Weekly")
            }

            Button {
                frequency = Memo.Frequency.monthly.rawValue
            } label: {
                Text("Monthly")
            }

            Button {
                frequency = Memo.Frequency.yearly.rawValue
            } label: {
                Text("Yearly")
            }
        } label: {
            Text("\(frequency.isEmpty ? "Repeat" : frequency.capitalized)")
                .foregroundColor(theme.fontBright)
                .font(.body.weight(.medium))
                .padding(Dims.spacingSmall)
                .background(theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
        }
    }
}

#Preview {
    MemoFrequencyComponent(
        frequency: .constant("daily"),
        theme: DarkTheme()
    )
}
