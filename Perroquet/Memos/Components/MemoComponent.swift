//
//  MemoComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct MemoComponent: View {
    @EnvironmentObject private var appVm: AppViewModel

    let memo: Memo
    let listener: MemoListener?

    @State private var isPresentingMemoView = false

    var body: some View {

        HStack(alignment: .center, spacing: Dims.spacingRegular) {

            Button(action: {
                onTapMarkAsComplete()
            }, label: {
                Image(systemName: memo.frequency != nil ? "repeat.circle" : memo.status == Memo.Status.pending.rawValue ? "circle" : "checkmark.circle.fill")
                    .foregroundColor(buttonColor())
                    .font(.body.weight(.bold))
                    .dynamicTypeSize(.small ... .accessibility1)
            })
            .disabled(memo.frequency != nil)

            Button(action: {
                isPresentingMemoView = true
            }, label: {
                VStack(alignment: .leading, spacing: Dims.spacingSmallest) {

                    Text(memo.title)
                        .foregroundColor(appVm.theme.fontNormal)
                        .font(.body.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)

                    HStack(alignment: .center, spacing: Dims.spacingSmall) {
                        Text("\(Date(timeIntervalSince1970: TimeInterval(memo.triggerAt) / 1000).formatted(date: .abbreviated, time: .shortened))")
                            .foregroundColor(appVm.theme.fontBright)
                            .font(.caption2.weight(.medium))
                            .lineLimit(1)

                        if memo.frequency != nil {
                            Text("\(memo.frequency!)")
                                .foregroundColor(.yellow)
                                .font(.caption2.weight(.medium))
                                .lineLimit(1)
                        }
                    }

                }
            })
            .sheet(isPresented: $isPresentingMemoView) {
                MemoView(vm: .init(wrappedValue: .init(memo: memo, listener: listener)))
                    .environmentObject(appVm)
                    .presentationDetents([.medium, .large])
            }

        }

    }

    func buttonColor() -> Color {
        if memo.status == Memo.Status.complete.rawValue {
            return appVm.theme.fontNormal
        }

        switch memo.priority {
        case Memo.Priority.high.rawValue:
            return Color.red
        case Memo.Priority.medium.rawValue:
            return Color.yellow
        case Memo.Priority.low.rawValue:
            return Color.blue
        default:
            return appVm.theme.fontDim
        }
    }

    func onTapMarkAsComplete() {
        Task {
            let newStatus = memo.status == Memo.Status.pending.rawValue ? Memo.Status.complete.rawValue : Memo.Status.pending.rawValue
            let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds

            let tempMemo = Memo(
                id: memo.id,
                userId: memo.userId,
                title: memo.title,
                description: memo.description,
                priority: memo.priority,
                status: newStatus,
                visibility: memo.visibility,
                frequency: memo.frequency,
                triggerAt: memo.triggerAt,
                updatedAt: currentTimeInMillis,
                createdAt: memo.createdAt
            )

            Stash.shared.insertMemo(memo: tempMemo)

            let notificator = Notificator()
            if newStatus == Memo.Status.complete.rawValue {
                notificator.clearNotifications(ids: [memo.id])
                notificator.delete(ids: [memo.id])
            } else if newStatus == Memo.Status.pending.rawValue {
                await notificator.schedule(notification: memo.toLocalNotification())
            }

            DispatchQueue.main.async {
                self.listener?.onEditMemo(tempMemo)
            }

            let dto = EditMemoDto(
                title: nil,
                description: nil,
                priority: nil,
                status: newStatus,
                visibility: nil,
                frequency: nil,
                triggerAt: nil
            )

            guard let accessToken = await AuthMan.shared.accessToken() else { return }
            let result = await MemosService(url: Config.BACKEND_URL).editMemo(id: memo.id, dto: dto, accessToken: accessToken)

            switch result {
            case .success:
                print("success")
            case .failure(let apiError):
                print(apiError.message)
            }
        }
    }
}

#Preview {
    MemoComponent(
        memo: Memo(
            id: "123",
            userId: "321",
            title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            priority: Memo.Priority.medium.rawValue,
            status: Memo.Status.pending.rawValue,
            visibility: 0,
//            frequency: Memo.Frequency.daily.rawValue,
            frequency: nil,
            triggerAt: 1708358620664,
            updatedAt: 1708358620664,
            createdAt: 1708358620664
        ),
        listener: nil
    )
    .environmentObject(AppViewModel())
}
