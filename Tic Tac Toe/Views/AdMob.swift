//
//  AdMob.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 6/8/21.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class BannerVC: UIViewControllerRepresentable  {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Test Key
        view.adUnitID = "ca-app-pub-8272098758489712/7419384232" //Real Key
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner:View{
    var body: some View{
            BannerVC()
                .frame(width: 320, height: 50, alignment: .center)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
