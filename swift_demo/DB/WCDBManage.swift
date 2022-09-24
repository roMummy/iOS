//
//  WCDBManage.swift
//  PdfConver
//
//  Created by FSKJ on 2022/5/26.
//

import Foundation
import WCDBSwift

struct WCDBDataBasePath {
    let dbPath = FZDirPath.db.bridge.appendingPathComponent("PdfConver.db")
}

class WCDBManage: NSObject {
    static let shared = WCDBManage()

    let dataBasePath = URL(fileURLWithPath: WCDBDataBasePath().dbPath)
    var dataBase: Database?
    override private init() {
        super.init()
        dataBase = createDb()
    }

    /// 创建db
    private func createDb() -> Database {
        debugPrint("数据库路径==\(dataBasePath.absoluteString)")
        return Database(withFileURL: dataBasePath)
    }

    /// 创建表
    func createTable<T: TableDecodable>(table: String, of type: T.Type) {
        do {
            try dataBase?.create(table: table, of: type)
        } catch { }
    }

    /// 插入
    func insertToDb<T: TableEncodable>(objects: [T], table: String) {
        do {
            try dataBase?.run(transaction: {
                try dataBase?.insert(objects: objects, intoTable: table)
            })
        } catch {}
    }

    /// 修改
    @discardableResult
    func updateToDb<T: TableEncodable>(table: String, on propertys: [PropertyConvertible], with object: T, where condition: Condition? = nil) -> Bool {
        do {
            try dataBase?.update(table: table, on: propertys, with: object, where: condition)
        } catch {
            return false
        }
        return true
    }

    /// 插入或更新
    @discardableResult
    func insertOrUpdateToDb<T: TableEncodable>(table: String, on propertys: [PropertyConvertible]? = nil, with object: [T], where condition: Condition? = nil) -> Bool {
        do {
            try dataBase?.insertOrReplace(objects: object, on: propertys, intoTable: table)
        } catch {
            return false
        }
        return true
    }

    /// 删除
    @discardableResult
    func deleteFromDb(fromTable: String, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: WCDBSwift.Offset? = nil) -> Bool {
        do {
            try dataBase?.run(transaction: {
                try dataBase?.delete(fromTable: fromTable, where: condition, orderBy: orderList, limit: limit, offset: offset)
            })
        } catch {
            return false
        }
        return true
    }

    /// 查询
    func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where: condition, orderBy: orderList, limit: limit, offset: offset))!
            return allObjects
        } catch {}
        return nil
    }

    /// 查询单条数据
    func qureyObjectFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil) -> T? {
        do {
            let object: T? = try (dataBase?.getObject(fromTable: fromTable, where: condition, orderBy: orderList))
//            debugPrint("\(object)")
            return object
        } catch {
            
        }
        return nil
    }
}
