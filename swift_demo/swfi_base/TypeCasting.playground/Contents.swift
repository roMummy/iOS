//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 *      类型转换 is as
 */

class MediaItem {
    var name:String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "111", director:"111"),
    Song(name: "222", artist:"222"),
    Movie(name: "333", director:"333"),
    Song(name: "444", artist:"444"),
    Movie(name: "555", director:"555")
]

///检查类型 is

var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    }else if item is Song {
        songCount += 1
    }

}
print(movieCount)
print(songCount)

///向下转型 as

for item in library {
    if let movie = item as? Movie {
        print(movie.name)
    }else if let song = item as? Song {
        print(song.name)
    }
   
}

///Any 和 AnyObject 的类型转换 
//Any 可以表示任何类型
//AnyObject 可以表示任何类类型的实例

var things = [Any]()

things.append(0)
things.append("1")
let optionalNumber:Int? = 1
things.append(optionalNumber as Any)







		