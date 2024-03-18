//
//  ProfileView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: ProfileViewModel

    @ScaledMetric var scale: CGFloat = 1

    init(vm: StateObject<ProfileViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: true) {

            VStack(alignment: .center, spacing: Dims.spacingRegular) {

                HStack(alignment: .center, spacing: Dims.spacingRegular) {
                    Spacer()

                    Button(action: {
                        AuthMan.shared.onSignout()
                    }, label: {
                        Text("Signout")
                            .foregroundColor(appVm.theme.fontBright)
                            .font(.caption.weight(.semibold))
                            .padding(Dims.spacingSmall)
                            .background(appVm.theme.primaryDark)
                            .cornerRadius(Dims.cornerRadius)
                    })
                }

                HStack(alignment: .center, spacing: Dims.spacingRegular) {

                    let imageSize = (UIFont.preferredFont(forTextStyle: .body).pointSize * 3) * scale

                    Image("perroquet-app-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(imageSize / 2)

                    Text(vm.quote)
                        .foregroundColor(appVm.theme.fontNormal)
                        .font(.body.weight(.regular))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .animation(.easeInOut, value: vm.quote)

                }
                .padding(Dims.spacingRegular)
                .background(appVm.theme.primaryDark)
                .cornerRadius(9999)
                .frame(maxWidth: Dims.viewMaxWidth2)

                Button {
                    appVm.theme = LightTheme()
                } label: {
                    Text("Light Theme")
                }

                Button {
                    appVm.theme = DarkTheme()
                } label: {
                    Text("Dark Theme")
                }

                Button {
                    appVm.theme = SlateTheme()
                } label: {
                    Text("Slate Theme")
                }

                Button {
                    Stash.shared.clear()
                } label: {
                    Text("Clear Cache")
                }

            } // LazyVStack
            .padding(Dims.spacingRegular)

        } // ScrollView
        .refreshable {
            vm.load()
        }

    }

    func accountSection() -> some View {
        VStack(alignment: .leading, spacing: Dims.spacingSmall) {

            Text("ACCOUNT")
                .foregroundColor(appVm.theme.fontDim)
                .font(.caption.weight(.bold))

            VStack(alignment: .leading, spacing: 0) {

            }
        }
    }

    func appSettingsSection() {

    }

    func supportSection() {

    }

    func moreSection() {

    }
}

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
