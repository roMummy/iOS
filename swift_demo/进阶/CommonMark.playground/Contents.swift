import UIKit


func cmark_markdown_to_html(_ text: UnsafePointer<Int8>!,_ len: Int,_ options: Int32) -> UnsafeMutablePointer<Int8>! {
  
}

func markdownToHtml(input: String) -> String {
  let outString = cmark_markdown_to_html(input, input.utf8.count, 0)!
  return String(cString: outString)
}


