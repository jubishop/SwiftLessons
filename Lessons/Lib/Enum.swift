import SwiftUI

// See https://stackoverflow.com/questions/59295206/how-do-you-use-enumerated-with-foreach-in-swiftui/63145650#63145650
// use func enumeratedArray() ?

func EnumList<T: Identifiable, V: View>(_ ary: Array<T>,
                                        block:@escaping (Int, T) -> V) ->
    List<Never, ForEach<Array<(offset: Int, element: T)>, T.ID, HStack<V>>> {
  return List(Array(ary.enumerated()), id: \.element.id) { idx, item in
    block(idx, item)
  }
}

func EnumForEach<T: Identifiable, V: View>(_ ary: Array<T>,
                                           block:@escaping (Int, T) -> V) ->
    ForEach<Array<(offset: Int, element: T)>, T.ID, V> {
  return ForEach(Array(ary.enumerated()), id: \.element.id) { idx, item in
    block(idx, item)
  }
}
