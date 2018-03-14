//
//  DataBaseManager.swift
//  Test
//
//  Created by TW on 2018/1/17.
//  Copyright © 2018年 lml. All rights reserved.
//

import Foundation
import FMDB

class DataBaseManager {
    fileprivate var database: FMDatabase //数据库
    open static let share: DataBaseManager = DataBaseManager()
    init() {
        //文件路径
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("UserActionData.sqlite")
        //数据库
        database = FMDatabase(url: fileURL)
        guard database.open() else {
            print("不能打开数据库")
            return
        }
        
        do {
            //创建loanList表
            try database.executeUpdate("create table if not exists loanList_table" + "(" +
                                       "id integer primary key autoincrement," +
                                       "loanNo text," +
                                       "loanType text," +
                                       "loanProduct text," +
                                       "loanMoney text," +
                                       "loanChannel text," +
                                       "loanTime text," +
                                       "loanResult text," +
                                       "loanConfirm text," +
                                       "loanState text" + ")", values: nil)
            //创建eventList表
            try database.executeUpdate("create table if not exists eventList_table" + "(" +
                                        "eventName text," +
                                        "result text," +
                                        "description text," +
                                        "time text" + ")", values: nil)
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
    // MARK: - 插入表
    //插入借款数据
    func insertDataToLoanList(model: UserActionLoanListModel) {
        guard database.open() else {
            print("database open fail")
            return
        }
        do {
            try database.executeUpdate("""
                                        insert into loanList_table(
                                        loanNo,
                                        loanType,
                                        loanProduct,
                                        loanMoney,
                                        loanChannel,
                                        loanTime,
                                        loanResult,
                                        loanConfirm,
                                        loanState)
                                        values (?, ?, ?, ?, ?, ?, ?, ?, ?)
                                        """, values: [model.loanNo,
                                                      model.loanType.rawValue,
                                                      model.loanProduct,
                                                      model.loanMoney,
                                                      model.loanChannel,
                                                      model.loanTime,
                                                      model.loanResult,
                                                      model.loanConfirm,
                                                      model.loanState])
        } catch {
            print("insert data fail")
        }
        database.close()
    }
    //插入事件数据
    func insertDataToEvent(model: UserActionEventListModel) {
        guard database.open() else {
            print("database open fail")
            return
        }
        do {
            try database.executeUpdate("""
                                        insert into eventList_table(
                                        eventName,
                                        result,
                                        description,
                                        time)
                                        values (?, ?, ?, ?)
                                        """, values: [model.eventName,
                                                      model.result,
                                                      model.description,
                                                      model.time])
        } catch {
            print("insert data fail")
        }
        database.close()
    }
    
    // MARK: - 获取数据
    //获取借款数据
    func getLoanlistData() -> [[[String : String]]] {
        var data: [[[String : String]]] = []
        guard database.open() else {
            print("database open fail")
            return []
        }
        do {
            let result = try database.executeQuery("SELECT * FROM loanList_table", values: nil)
            while result.next() {
                guard let loanNo = result.string(forColumn: "loanNo"),
                    let loanType = result.string(forColumn: "loanType"),
                    let loanProduct = result.string(forColumn: "loanProduct"),
                    let loanMoney = result.string(forColumn: "loanMoney"),
                    let loanChannel = result.string(forColumn: "loanChannel"),
                    let loanTime = result.string(forColumn: "loanTime"),
                    let loanResult = result.string(forColumn: "loanResult"),
                    let loanConfirm = result.string(forColumn: "loanConfirm"),
                    let loanState = result.string(forColumn: "loanState") else {
                        database.close()
                        return []
                }
                data.append([["loanNo": loanNo],
                             ["loanType": loanType],
                             ["loanProduct": loanProduct],
                             ["loanMoney": loanMoney],
                             ["loanChannel": loanChannel],
                             ["loanTime": loanTime],
                             ["loanResult": loanResult],
                             ["loanConfirm": loanConfirm],
                             ["loanState": loanState]
                            ])
            }
        } catch  {
            print("getLoanlistData querey data fail")
        }
        database.close()
        return data
    }
    
    //获取事件数据
    func getEventlistData() -> [[[String : String]]] {
        var data: [[[String : String]]] = []
        guard database.open() else {
            print("database open fail")
            return []
        }
        do {
            let resultEvent = try database.executeQuery("SELECT * FROM eventList_table", values: nil)
            while resultEvent.next() {                
                guard let eventName = resultEvent.string(forColumn: "eventName"),
                    let result = resultEvent.string(forColumn: "result"),
                    let description = resultEvent.string(forColumn: "description"),
                    let time = resultEvent.string(forColumn: "time") else {
                        database.close()
                        return []
                }
                data.append([["eventName": eventName],
                             ["result": result],
                             ["description": description],
                             ["time": time]
                            ])
            }
            
        } catch  {
            print("getLoanlistData querey data fail")
        }
        database.close()
        return data
    }
    
    // MARK: - 删除数据
    //删除借款所有数据
    func deleteLoanlistAllData() {
        guard database.open() else {
            print("database open fail")
            return
        }
        do {
            try database.executeUpdate("delete from userActionData_table", values: nil)
        } catch {
            print("loan delete fail")
        }
        database.close()
    }
    func deleteEventlistAllData() {
        guard database.open() else {
            print("database open fail")
            return
        }
        do {
            try database.executeUpdate("delete from userActionData_table", values: nil)
        } catch {
            print("loan delete fail")
        }
        database.close()
    }
}
