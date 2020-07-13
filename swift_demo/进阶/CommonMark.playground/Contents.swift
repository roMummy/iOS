import UIKit


/** 将 'text' (假设是 UTF-8 编码的字符串，且长度为 'len')”
“* 从 CommonMark Markdown 转换为 HTML,
* 返回一个以 null 结尾的 UTF-8 编码的字符串。
*/
func cmark_markdown_to_html(_ text: UnsafePointer<Int8>!,_ len: Int,_ options: Int32) -> UnsafeMutablePointer<Int8>! {
  return ""
}

func markdownToHtml(input: String) -> String {
  let outString = cmark_markdown_to_html(input, input.utf8.count, 0)!
  return String(cString: outString)
}

public class Node {
  let node: OpaquePointer
  
  init(node: OpaquePointer) {
    self.node = node
  }
  
  deinit {
    guard type == CMARK_NODE else {
      <#statements#>
    }
  }
}



