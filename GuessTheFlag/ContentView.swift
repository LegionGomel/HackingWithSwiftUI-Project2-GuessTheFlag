//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yuri Ershov on 11.01.22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State var tappedAnswer = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionsRemaining = 8
    @State private var endingGame = false
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    
                    VStack {
                        Text("Tap the flag off")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            tappedAnswer = number
                            flagTapped(number)
                        } label: {
                            FlagImage(number: number, country: $countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreTitle == "Correct" ? "Your score is \(userScore)" : "Wrong! That's the flag of \(countries[tappedAnswer])")
        }
        .alert("The End", isPresented: $endingGame) {
            Button("Restart", action: reset)
        } message: {
            Text("Your final score is: \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        questionsRemaining -= 1
        guard questionsRemaining > 0 else {
            endingGame = true
            return
        }
        if number == correctAnswer {
            userScore += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        userScore = 0
        questionsRemaining = 8
        askQuestion()
    }
    
    // challenge from p.3
    struct FlagImage : View {
        let number: Int
        @Binding var country: String
        var body: some View {
            Image(country)
            //tells SwiftUI to render the original image pixels
            //rather than trying to recolor them as a button
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
}

// challenge from p.3
struct BigBlueTitle: ViewModifier {
    
    func body(content: Content) -> some View {
            content
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
        }
}

extension View {
    func bigBlueTitle() -> some View {
            modifier(BigBlueTitle())
        }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


