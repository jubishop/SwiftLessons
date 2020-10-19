import SwiftUI

func EnumList<T: Identifiable, V: View>(_ ary: Array<T>,
                                        block:@escaping (Int, T) -> V) ->
    List<Never, ForEach<Array<(offset: Int, element: T)>, T.ID, HStack<V>>> {
  return List(ary.enumeratedArray(), id: \.element.id) { idx, item in
    block(idx, item)
  }
}

func EnumForEach<T: Identifiable, V: View>(_ ary: Array<T>,
                                           block:@escaping (Int, T) -> V) ->
    ForEach<Array<(offset: Int, element: T)>, T.ID, V> {
  return ForEach(ary.enumeratedArray(), id: \.element.id) { idx, item in
    block(idx, item)
  }
}
