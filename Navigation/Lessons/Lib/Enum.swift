import SwiftUI

func EnumList<T: Identifiable, V: View>(
  _ ary: [T],
  block: @escaping (Int, T) -> V
) -> List<Never, ForEach<[(offset: Int, element: T)], T.ID, HStack<V>>> {
  List(ary.enumeratedArray(), id: \.element.id) { idx, item in
    block(idx, item)
  }
}

func EnumForEach<T: Identifiable, V: View>(
  _ ary: [T],
  block: @escaping (Int, T) -> V
) -> ForEach<[(offset: Int, element: T)], T.ID, V> {
  ForEach(ary.enumeratedArray(), id: \.element.id) { idx, item in
    block(idx, item)
  }
}
