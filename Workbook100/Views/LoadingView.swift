//
//  LoadingView.swift
//  Workbook100
//
//  Created by Eddie Char on 6/18/22.
//

import SwiftUI

struct LoadingView: View {
    @State var zAxisRotation = 0.0
    @State var scale = 0.5
    
    var body: some View {
        ZStack {
//            Rectangle()
//                .frame(width: 250, height: 250, alignment: .center)
//                .foregroundColor(.green)
//                .cornerRadius(16)
//
//            Rectangle()
//                .frame(width: 250, height: 250, alignment: .center)
//                .foregroundColor(.white)
//                .cornerRadius(16)
//                .opacity(0.8)
            

            Flower(numPetals: 12)
                .scaleEffect(scale)
                .rotationEffect(.degrees(zAxisRotation), anchor: .center)
                .onAppear {
                    let baseAnimation = Animation.linear(duration: 40)
                    let repeated = baseAnimation.repeatForever()
                    
                    withAnimation(repeated) {
                        zAxisRotation = 360 * 20 
//                        scale = 3
                    }
                }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

struct Flower: View {
    @State var numPetals: Int

    var body: some View {
        ForEach((0..<numPetals), id: \.self) {
            Petal(color: Color(hue: Double($0 * (360 / numPetals)) / 360,
                               saturation: 1.0,
                               brightness: 1.0),
                  rotation: Double($0 * (360 / numPetals)))
        }
    }

    struct Petal: View {
        @State var color: Color
        @State var rotation: Double
        
        var body: some View {
            Capsule()
//                .stroke(lineWidth: 5)
                .offset(y: 50)
                .frame(width: 17, height: 35)
                .opacity(0.5)
                .foregroundColor(color)
                .rotationEffect(.degrees(rotation))
        }
    }
}

