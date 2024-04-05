//
//  AppearanceView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/29/24.
//

import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: AppearanceViewModel

    @ScaledMetric var scale: CGFloat = 1

    init(vm: StateObject<AppearanceViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: true) {

            VStack(alignment: .center, spacing: Dims.spacingRegular) {

                userInterfaceSection()

            }
            .frame(maxWidth: .infinity)
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        }
        .background(appVm.theme.primary.ignoresSafeArea(.all))

    }

    func userInterfaceSection() -> some View {
        ListSectionComponent(title: "USER INTERFACE", theme: appVm.theme) {

            ListItemOptionComponent(
                title: "Theme",
                value: appVm.theme.displayName(),
                options: Themes.allCases.map { theme in
                    return (
                        theme.value().displayName(), { setTheme(theme.value()) }
                    )
                },
                theme: appVm.theme
            )

        }
        .frame(maxWidth: Dims.viewMaxWidth2)
    }

    func setTheme(_ theme: Theme) {
        appVm.theme = theme
    }
}

#Preview {
    AppearanceView()
        .environmentObject(AppViewModel())
}
