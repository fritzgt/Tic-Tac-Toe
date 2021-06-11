////
////  LottieView.swift
////  Tic Tac Toe
////
////  Created by FGT MAC on 6/6/21.
////
//
//import SwiftUI
//import Lottie
//
//
////MARK: - LottieView
//struct LottieView: UIViewRepresentable {
//    let animationView = AnimationView()
//    var animationName: String
//    
//    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
//        let view = UIView()
//        
//        //Setup the animation
//        let animation = Animation.named(animationName)
//        animationView.animation = animation
//        animationView.contentMode = .scaleAspectFit
//        animationView.play()
//        
//        //Constrains
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(animationView)
//        
//        NSLayoutConstraint.activate([
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
//        ])
//        
//        return view
//    }
//    //Required to conform to UIViewRepresentable
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
//}
