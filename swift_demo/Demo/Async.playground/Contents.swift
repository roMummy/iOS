import UIKit

/// - form: https://onevcat.com/2021/09/structured-concurrency/
var greeting = "Hello, playground"

struct TaskGroupSamlpe {
//    func start() async {
//        print("start")
//
//        let v = await withTaskGroup(of: Int.self, body: { group -> Int in
//            var value = 0
//            for i in 0..<3 {
//                group.addTask {
//                    await work(i)
//                }
//            }
//            print("task added")
//
//            for await result in group {
//                print("get result \(result)")
//                value += result
//    //                break
//            }
//
//            print("task ended")
//            return value
//        })
//
//        print("End \(v)")
//    }
//    func start() async {
//        print("start")
//        // 第一层任务组
//        let v = await withTaskGroup(of: Int.self, body: { group in
//            group.addTask {
//                // 第二层任务组
//                await withTaskGroup(of: Int.self, body: { innerGroup -> Int in
//                    innerGroup.addTask {
//                        await work(0)
//                    }
//                    innerGroup.addTask {
//                        await work(2)
//                    }
//                    return await innerGroup.reduce(0) { result, value in
//                        result + value
//                    }
//                })
//            }
//            
//            group.addTask {
//                await work(1)
//            }
//        })
//
//        print("End \(v)")
//    }
    
    func start() async {
        async let v02: Int = {
            async let v0 = work(0)
            async let v2 = work(2)
            return await v0 + v2
        }()
        async let v1 = work(1)
        _ = await v02 + v1
        print("end")
    }

//    func start() async {
//        print("Start")
//        let v0 = await work(0)
//        let v1 = await work(1)
//        let v2 = await work(2)
//        print("Task added")
//
//        let result =  v0 + v1 + v2
//        print("Task ended")
//        print("End. Result: \(result)")
//    }

    private func work(_ value: Int) async -> Int {
        print("start work \(value)")
        await Task.sleep(UInt64(value) * NSEC_PER_SEC)
        print("work \(value) done")
        return value
    }
}

Task {
    await TaskGroupSamlpe().start()
}
