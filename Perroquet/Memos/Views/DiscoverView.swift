//
//  DiscoverView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: DiscoverViewModel

    init(vm: StateObject<DiscoverViewModel> = .init(wrappedValue: .init(dto: .init(
        id: nil,
        userId: nil,
        search: nil,
        priority: nil,
        status: nil,
        visibility: nil,
        sort: nil,
        cursor: nil,
        limit: nil
    )))) {
        _vm = vm
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: true) {

            LazyVStack(alignment: .center, spacing: Dims.spacingRegular) {

                Text("Discover")
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                    .foregroundColor(appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)

                if !vm.memos.isEmpty {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(vm.memos) { memo in
                            MemoComponent(memo: memo, listener: vm)
                                .environmentObject(appVm)
                        }
                    }
                    .padding(Dims.spacingRegular)
                    .background(appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                } else {
                    HStack(alignment: .center, spacing: Dims.spacingRegular) {

                        Text("Nothing here")

                        Spacer()

                    }
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                }

            } // LazyVStack
            .padding(Dims.spacingRegular)

        } // ScrollView
        .refreshable {
            await vm.load()
        }

    }
}

#Preview {
    DiscoverView()
}
