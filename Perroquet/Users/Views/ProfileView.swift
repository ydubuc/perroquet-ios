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
                .frame(maxWidth: Dims.viewMaxWidth2)

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

                accountSection()

                appSettingsSection()

                supportSection()

                moreSection()

            } // VStack
            .frame(maxWidth: .infinity)
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
        .refreshable {
            vm.load()
        }

    }

    func accountSection() -> some View {
        ListSectionComponent(title: "ACCOUNT", theme: appVm.theme) {

            ListItemComponent(
                icon: "person.crop.circle",
                title: "Account Settings",
                theme: appVm.theme
            ) {
                print("yay")
            }

            ListItemComponent(
                icon: "iphone.circle",
                title: "Devices",
                theme: appVm.theme
            ) {
                print("yay")
            }

        }
        .frame(maxWidth: Dims.viewMaxWidth2)
    }

    func appSettingsSection() -> some View {
        ListSectionComponent(title: "APP SETTINGS", theme: appVm.theme) {

            ListItemComponent(
                icon: "mountain.2.circle",
                title: "Appearance",
                theme: appVm.theme
            ) {
                vm.isPresentingAppearanceView = true
            }
            .sheet(isPresented: $vm.isPresentingAppearanceView) {
                AppearanceView()
                    .environmentObject(appVm)
            }

            ListItemComponent(
                icon: "bell.circle",
                title: "Notifications",
                theme: appVm.theme
            ) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }

        }
        .frame(maxWidth: Dims.viewMaxWidth2)
    }

    func supportSection() -> some View {
        ListSectionComponent(title: "SUPPORT", theme: appVm.theme) {

            ListItemComponent(
                icon: "questionmark.circle",
                title: "Help & FAQ",
                theme: appVm.theme
            ) {
                vm.isPresentingHelpView = true
            }
            .sheet(isPresented: $vm.isPresentingHelpView) {
                HelpView()
                    .environmentObject(appVm)
            }

            ListItemComponent(
                icon: "star.circle",
                title: "Rate This App",
                theme: appVm.theme
            ) {
                UIApplication.shared.open(URL(string: Config.APP_STORE_URL)!)
            }

            ListItemComponent(
                icon: "exclamationmark.bubble.circle",
                title: "Send Feedback",
                theme: appVm.theme
            ) {
                vm.isPresentingSupportView = true
            }
            .sheet(isPresented: $vm.isPresentingSupportView) {
                SafariView(url: URL(string: Config.SUPPORT_URL)!, theme: appVm.theme)
                    .ignoresSafeArea(.all)
            }

            ShareLink(item: URL(string: Config.APP_STORE_URL)!) {
                ListItemComponent(
                    icon: "square.and.arrow.up.circle",
                    title: "Share This App",
                    theme: appVm.theme
                ) { }
                    .disabled(true)
            }

        }
        .frame(maxWidth: Dims.viewMaxWidth2)
    }

    func moreSection() -> some View {
        ListSectionComponent(title: "MORE", theme: appVm.theme) {

            ListItemComponent(
                icon: "lock.circle",
                title: "Privacy Policy",
                theme: appVm.theme
            ) {
                vm.isPresentingPrivacyView = true
            }
            .sheet(isPresented: $vm.isPresentingPrivacyView) {
                SafariView(url: URL(string: Config.PRIVACY_URL)!, theme: appVm.theme)
                    .ignoresSafeArea(.all)
            }

            ListItemComponent(
                icon: "list.bullet.circle",
                title: "Terms & Conditions",
                theme: appVm.theme
            ) {
                vm.isPresentingTermsView = true
            }
            .sheet(isPresented: $vm.isPresentingTermsView) {
                SafariView(url: URL(string: Config.TERMS_URL)!, theme: appVm.theme)
                    .ignoresSafeArea(.all)
            }

            ListItemComponent(
                icon: "trophy.circle",
                title: "Acknowledgements",
                theme: appVm.theme
            ) {
                vm.isPresentingAcknowledgementsView = true
            }
            .sheet(isPresented: $vm.isPresentingAcknowledgementsView) {
                AcknowledgementsView()
                    .environmentObject(appVm)
            }

        }
        .frame(maxWidth: Dims.viewMaxWidth2)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
