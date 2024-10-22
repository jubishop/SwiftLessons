import SwiftUI

struct FlagImage: View {
  let country: String
  let selectedCountry: String

  private let cornerRadius: CGFloat = 10

  var isSelected: Bool { selectedCountry == country }
  var isSelectedOrEmpty: Bool { selectedCountry == "" || isSelected }

  var body: some View {
    Image(country)
      .shadow(radius: 5)
      .clipShape(RoundedRectangle(cornerRadius: CGFloat(cornerRadius)))
      .overlay(
        RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
          .stroke(Color.black, lineWidth: 1)
      )
      .rotation3DEffect(
        .degrees(isSelected ? 360 : 0),
        axis: (x: 0, y: 1, z: 0)
      )
      .opacity(isSelectedOrEmpty ? 1 : 0.25)
      .scaleEffect(isSelectedOrEmpty ? 1 : 0.25)
  }
}

struct ContentView: View {
  @State private var countries = [
    "Estonia",
    "France",
    "Germany",
    "Ireland",
    "Italy",
    "Nigeria",
    "Poland",
    "Spain",
    "UK",
    "Ukraine",
    "US",
  ]
  .shuffled()
  @State private var correctAnswer = Int.random(in: 0...2)
  @State private var selectedCountry = ""

  @State private var score = 0
  @State private var questionsAsked = 0
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var scoreMessage = ""
  @State private var buttonMessage = ""

  var body: some View {
    ZStack {
      RadialGradient(
        stops: [
          .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
          .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
        ],
        center: .top,
        startRadius: 200,
        endRadius: 400
      )
      .ignoresSafeArea()

      VStack {
        Spacer()
        Text("Guess the Flag")
          .font(.largeTitle.bold())
          .foregroundStyle(.white)
        VStack(spacing: 20) {
          VStack {
            Text("Tap the flag of")
              .foregroundStyle(.secondary)
              .font(.subheadline.weight(.heavy))
            Text(countries[correctAnswer])
              .font(.largeTitle.weight(.semibold))
          }

          ForEach(0..<3) { number in
            Button {
              withAnimation(.easeInOut(duration: 2)) {
                selectedCountry = countries[number]
              }
              flagTapped(number)
            } label: {
              FlagImage(
                country: countries[number],
                selectedCountry: selectedCountry
              )
            }
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 20))

        Spacer()
        Spacer()
        Text("Score: \(score)")
          .foregroundStyle(.white)
          .font(.title.bold())
        Spacer()
      }
      .padding()
    }
    .alert(scoreTitle, isPresented: $showingScore) {
      Button(buttonMessage, action: askQuestion)
    } message: {
      Text(scoreMessage)
    }
  }

  func askQuestion() {
    if questionsAsked == 8 {
      questionsAsked = 0
      score = 0
    }
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    selectedCountry = ""
  }

  func flagTapped(_ number: Int) {
    if number == correctAnswer {
      score += 1
      scoreTitle = "Correct"
    } else {
      scoreTitle = "Wrong, you clicked the flag of \(countries[number])"
    }

    questionsAsked += 1
    if questionsAsked == 8 {
      scoreMessage = "Your final score is \(score)."
      buttonMessage = "Play again"
    } else {
      let questionsLeft = 8 - questionsAsked
      let questionWord = questionsLeft == 1 ? "question" : "questions"
      scoreMessage = "Your score is \(score). You have \(questionsLeft) \(questionWord) left."
      buttonMessage = "Continue"
    }

    showingScore = true
  }
}

#Preview {
  ContentView()
}
