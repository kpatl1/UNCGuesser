//
//  RoundOverView.swift
//  UNCGuesser
//
//  Created by Kishan Patel on 11/29/22.
//

import SwiftUI

struct RoundOverView: View {
    var body: some View {
        ZStack {
            VStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ], center: .top, startRadius: 200, endRadius: 700)
                    .ignoresSafeArea()
            }
            Text("Round Over\n\nPlay again?")
                .font(.title.bold())
                .foregroundColor(.white)
                .position(x: 200, y: 90)
            Button(action: {}

            ) {
                Text("Yes")

                    .padding()
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .position(x: 200, y: 240)
            }
        }
    }
}

struct RoundOverView_Previews: PreviewProvider {
    static var previews: some View {
        RoundOverView()
    }
}
