//
//  UserActionLoanListModel.swift
//  Test
//
//  Created by TW on 2018/1/17.
//  Copyright © 2018年 lml. All rights reserved.
//

import Foundation
enum UserActionLoanType: String {//借款类型
    case pos = "长期贷"
    case pdl = "短平快"
}
struct UserActionLoanListModel {
    var loanNo: String  //借款单号
    var loanType: UserActionLoanType   //借款类型
    var loanProduct: String //借款产品
    var loanMoney: String   //借款金额
    var loanChannel: String //借款渠道
    var loanTime: String    //借款时间
    var loanResult: String  //申请结果
    var loanConfirm: String //确认结果
    var loanState: String   //借款状态
}
