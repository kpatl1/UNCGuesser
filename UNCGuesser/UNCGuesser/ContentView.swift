//
//  ContentView.swift
//  UNCGuesser
//
//  Created by Josh Myatt on 11/22/22.
//
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var locations = ["Abernethy Annex","Art Studio Building","Arts and Sciences Foundation", "Friday Center","FedEx Global Education Center","Davis Library","Health Sciences Library", "House Undergraduate Library"].shuffled()
    @State private var locationsDict = ["Abernethy Annex": [35.897587, -79.057671] ,"Art Studio Building":[35.931885, -79.058293],"Arts and Sciences Foundation": [35.918081, -79.046419], "Friday Center": [35.897316, -79.012161],"FedEx Global Education Center": [35.907817, -79.054528],"Davis Library":[35.910959, -79.047907],"Health Sciences Library":[35.908366, -79.052776], "House Undergraduate Library": [35.909768, -79.049045]]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.9, longitude: -79.05), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    @State private var shownLocations = [String]()
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
    var body: some View {
        NavigationStack{
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
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
                            
                            Text(locations[correctAnswer])
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
                                        self.locationPlaced = true
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
                        
                        Button(action: {verify(scoreCount: scoreCount, score: score); if locationPlaced {numGuesses += 1};}){
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
        if mapLocations.count != 0{
            mapLocations = []
        }
        mapLocations.append(newLocation)
    }
    
    func locationTapped() {
        
        if self.numGuesses > 3{
            showingScore = false
        }
        else{
            scoreTitle = String(score[scoreCount-1])
            showingScore = true
            //change button text
            if self.numGuesses == 2 {
                self.buttonState = "New Round"
            }
        }
        
    }
    
    func askQuestion() {
        locations.shuffle()
        if locations.count != shownLocations.count{
            let tempAnswer = Int.random(in: 0...2)
            if shownLocations.contains(locations[tempAnswer]){
                askQuestion()
            }
            correctAnswer = tempAnswer
        }
        else{
            locations.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    
    func newRound(roundNumber: Int){
        var totalScore = 0
        self.shouldHide = true
        self.scoreCount = 0
        self.numGuesses = -1
        self.roundNumber += 1
        //save average score for next game
        for scores in self.score {
            totalScore += scores
        }
        self.savedScore.append(totalScore/self.score.count)
        UserDefaults.standard.set(self.savedScore, forKey: "scoreArray")
        self.score.removeAll()
        self.shownLocations.removeAll()
        self.buttonState = "Continue"
        
    }
    
    func gameOver(){
        self.shownLocations.removeAll()
        self.roundNumber = 0
        self.scoreCount = 0
        self.numGuesses = -1
        self.score.removeAll()
        self.isGameOver = true
    }
    
    func verify(scoreCount: Int, score: [Int]){
        //make sure locations array has a value
        if mapLocations.count != 0 {
            self.scoreCount+=1
            let lat = (1000*(abs(mapLocations[0].latitude - locationsDict[locations[correctAnswer]]![0])))
            let long = (1000*(abs(mapLocations[0].longitude - locationsDict[locations[correctAnswer]]![1])))
            self.score.append(Int(100-(lat+long)/2))
            if numGuesses >= 3 && roundNumber <= 4{
                newRound(roundNumber: roundNumber)
            }
            else if roundNumber > 2{
                gameOver()
            }
            else{
                locationTapped()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

