//
//  MemoListener.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 3/19/24.
//

import Foundation

protocol MemoListener {
    func onCreateMemo(_ memo: Memo)
    func onEditMemo(_ memo: Memo)
    func onDeleteMemo(_ memo: Memo)
}
