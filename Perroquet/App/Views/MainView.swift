//
//  MainView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: MainViewModel

    init(vm: StateObject<MainViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {

        ZStack(alignment: .center) {

            LazyView(loadWhen: $vm.shouldLoadMemosView) {
                MemosView(
                    vm: .init(wrappedValue: .init(
                        memos: vm.stash.getMemos() ?? [],
                        dto: .init(
                            id: nil,
                            userId: vm.authMan.accessTokenClaims?.id,
                            search: nil,
                            priority: nil,
                            status: nil,
                            visibility: nil,
                            sort: "updated_at,asc",
                            cursor: nil,
                            limit: nil
                        )
                    ))
                )
            }
            .opacity(vm.currentTab == 0 ? 1 : 0)

            LazyView(loadWhen: $vm.shouldLoadDiscoverView) {
                DiscoverView(vm: .init(wrappedValue: .init(dto: .init(
                    id: nil,
                    userId: nil,
                    search: nil,
                    priority: nil,
                    status: nil,
                    visibility: 1,
                    sort: "trigger_at,asc",
                    cursor: "\(Date().timeIntervalSince1970.milliseconds),\(UUID().uuidString)",
                    limit: nil
                ))))
            }
            .opacity(vm.currentTab == 1 ? 1 : 0)

            LazyView(loadWhen: $vm.shouldLoadMemosView) {
                Text("requests")
            }
            .opacity(vm.currentTab == 3 ? 1 : 0)

            LazyView(loadWhen: $vm.shouldLoadProfileView) {
                ProfileView()
            }
            .opacity(vm.currentTab == 4 ? 1 : 0)

            VStack(alignment: .center, spacing: 0) {

                appVm.theme.primary
                    .frame(height: safeAreaInsets.top)
                    .ignoresSafeArea()

                Spacer()

                HStack(alignment: .center, spacing: 0) {

                    Button {
                        vm.switchToTab(0)
                    } label: {
                        Image(systemName: "list.bullet.circle")
                            .foregroundColor(vm.currentTab == 0 ? appVm.theme.fontBright : appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }

                    Button {
                        vm.switchToTab(1)
                    } label: {
                        Image(systemName: "safari")
                            .foregroundColor(vm.currentTab == 1 ? appVm.theme.fontBright : appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }

                    Button {
                        appVm.isPresentingCreateMemoView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(vm.currentTab == 2 ? appVm.theme.fontBright : appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }

                    Button {
                        vm.switchToTab(3)
                    } label: {
                        Image(systemName: "at.circle")
                            .foregroundColor(vm.currentTab == 3 ? appVm.theme.fontBright : appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }

                    Button {
                        vm.switchToTab(4)
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(vm.currentTab == 4 ? appVm.theme.fontBright : appVm.theme.fontNormal)
                            .font(.body.weight(.bold))
                            .dynamicTypeSize(.xSmall ... .accessibility1)
                            .padding(Dims.spacingRegular)
                    }

                } // HStack
                .background(appVm.theme.primaryLight)
                .cornerRadius(Dims.cornerRadius)
                .padding(.bottom, Dims.spacingRegular)

            }

        } // ZStack
        .environmentObject(appVm)
        .background(appVm.theme.primary)
        .onAppear {
            UIApplication.setWindowBackgroundColor(UIColor(appVm.theme.primaryDark))
        }

    }
}

#Preview {
    MainView()
}
