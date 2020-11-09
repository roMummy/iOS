import UIKit

var str = "Hello, playground"

//: ### 信号量
/*:
 
 dispatch_semaphore是GCD用来同步的一种方式，与他相关的共有三个函数，分别是

 * dispatch_semaphore_create：定义信号量
 * dispatch_semaphore_signal：使信号量+1
 * dispatch_semaphore_wait：使信号量-1

 当信号量为0时，就会做等待处理，这是其他线程如果访问的话就会让其等待。所以如果信号量在最开始的的时候被设置为1，那么就可以实现“锁”的功能：

 * 执行某段代码之前，执行dispatch_semaphore_wait函数，让信号量-1变为0，执行这段代码。
 * 此时如果其他线程过来访问这段代码，就要让其等待。
 * 当这段代码在当前线程结束以后，执行dispatch_semaphore_signal函数，令信号量再次+1，那么如果有正在等待的线程就可以访问了。

 需要注意的是：如果有多个线程等待，那么后来信号量恢复以后访问的顺序就是线程遇到dispatch_semaphore_wait的顺序。
 这也就是信号量和互斥锁的一个区别：互斥量用于线程的互斥，信号线用于线程的同步。


 * 互斥：是指某一资源同时只允许一个访问者对其进行访问，具有唯一性和排它性。但互斥无法限制访问者对资源的访问顺序，即访问是无序的。


 * 同步：是指在互斥的基础上（大多数情况），通过其它机制实现访问者对资源的有序访问。在大多数情况下，同步已经实现了互斥，特别是所有写入资源的情况必定是互斥的。也就是说使用信号量可以使多个线程有序访问某个资源。

 作者：J_Knight_
 链接：https://juejin.im/post/6844903554214264840
 来源：掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 */

func test1() {
  print("test1")
}

func test2() {
  print("test2")
}

let lock = DispatchSemaphore(value: 1)

test1()

// lock
lock.wait()
test2()
// unlock
lock.signal()

test1()


