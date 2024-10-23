extension Collection {
  func enumeratedArray() -> [(offset: Int, element: Self.Element)] {
    Array(self.enumerated())
  }
}
