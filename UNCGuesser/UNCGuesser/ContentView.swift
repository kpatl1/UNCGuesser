//
//  ContentView.swift
//  UNCGuesser
//
//  Created by Josh Myatt on 11/22/22.
//
//

import MapKit
import SwiftUI

struct ContentView: View {
    var utils = Utils()
    @State var showingScore = false
    @State var scoreTitle = ""
    @State var correctAnswer = Int.random(in: 0...2)
    @State var shownLocations = [String]()
    @State var mapLocations = [Location]()
    @State var scoreCount = 0
    @State var roundNumber = 1
    @State var numGuesses = 0
    @State var shouldHide = false
    @State var locationPlaced = false
    @State var isGameOver = false
    @State var score = [Int]()
    @State var savedScore = UserDefaults.standard.object(forKey: "scoreArray") as? [Int] ?? [Int]()
    @State var buttonState = "Confirm"
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.9, longitude: -79.05), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0, green: 49/255, blue: 102/255), location: 0.3),
                    .init(color: Color(red: 201/255, green: 234/255, blue: 253/255), location: 0.3)
                ], center: .top, startRadius: 200, endRadius: 700)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Guess the Location")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        VStack {
                            Text("Tap the location of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            
                            Text(utils.locations[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                        }
                        ZStack {
                            Map(coordinateRegion: $region, annotationItems: mapLocations) { location in
                                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                            }
                            .ignoresSafeArea()
                            Circle()
                                .fill(.blue)
                                .opacity(0.3)
                                .frame(width: 32, height: 32)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: region.center.latitude, longitude: region.center.longitude)
                                        addLocation(newLocation: newLocation)
                                        locationPlaced = true
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    .padding()
                                    .background(.black.opacity(0.75))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                                }
                            }
                        }
                        
                        Button(action: { verify(); if locationPlaced { numGuesses += 1 }}) {
                            Text(buttonState)
                                .padding()
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(30)
                        }
                 
                        Text("Round Number: \(roundNumber) ")
                            .bold()
                        Text("Guesses: \(numGuesses) ")
                        if savedScore.count > 0 {
                            Text("High Score: \(savedScore.max() ?? 0)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                .padding()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(scoreTitle)")
            }
        }
    }
    
    func addLocation(newLocation: Location) {
        if self.mapLocations.count != 0 {
            self.mapLocations = []
        }
        self.mapLocations.append(newLocation)
    }
    
    func locationTapped() {
        if self.numGuesses > 3 {
            self.showingScore = false
        }
        else {
            self.scoreTitle = String(self.score[self.scoreCount - 1])
            self.showingScore = true
            // change button text
            if self.numGuesses == 2 {
                self.buttonState = "New Round"
            }
        }
    }
    
    func askQuestion() {
        self.utils.locations.shuffle()
        if self.utils.locations.count != self.shownLocations.count {
            let tempAnswer = Int.random(in: 0...2)
            if self.shownLocations.contains(self.utils.locations[tempAnswer]) {
                self.askQuestion()
            }
            self.correctAnswer = tempAnswer
        }
        else {
            self.utils.locations.shuffle()
            self.correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func newRound() {
        var totalScore = 0
        self.shouldHide = true
        self.scoreCount = 0
        self.numGuesses = -1
        self.roundNumber += 1
        // save average score for next game
        for scores in self.score {
            totalScore += scores
        }
        self.savedScore.append(totalScore/self.score.count)
        UserDefaults.standard.set(self.savedScore, forKey: "scoreArray")
        self.score.removeAll()
        self.shownLocations.removeAll()
        self.buttonState = "Confirm"
    }
    
    func gameOver() {
        self.shownLocations.removeAll()
        self.roundNumber = 0
        self.scoreCount = 0
        self.numGuesses = -1
        self.score.removeAll()
        self.isGameOver = true
    }
    
    func verify() {
        // make sure locations array has a value
        if self.mapLocations.count != 0 {
            self.scoreCount += 1
            let lat = (1000*abs(self.mapLocations[0].latitude - self.utils.locationsDict[self.utils.locations[self.correctAnswer]]![0]))
            let long = (1000*abs(self.mapLocations[0].longitude - self.utils.locationsDict[self.utils.locations[self.correctAnswer]]![1]))
            self.score.append(Int(100 - (lat + long)/2))
            if self.numGuesses >= 3, self.roundNumber <= 4 {
                self.newRound()
            }
            else if self.roundNumber > 2 {
                self.gameOver()
            }
            else {
                self.locationTapped()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
