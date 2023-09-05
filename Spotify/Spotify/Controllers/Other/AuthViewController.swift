//
//  AuthViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import WebKit
import Alamofire

class AuthViewController: UIViewController {

    // MARK: - Stored-Prop
    public var completionHandler: ((Bool) -> Void)?
    
    // MARK: - UI Component
    private let webView: WKWebView = {
        
        let preferences: WKWebpagePreferences = WKWebpagePreferences()
        
        preferences.allowsContentJavaScript = true
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        
        config.defaultWebpagePreferences = preferences
        
        let webView: WKWebView = WKWebView(frame: .zero,
                                           configuration: config)
        
        return webView
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        
        self.title = "Sign In"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        self.webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        configureWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = self.view.bounds
    }

    private func configureWebView() -> Void {
        
        guard let url: URL = AuthManager.shared.signInURL else { return }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200 ..< 300)
            .response(queue: DispatchQueue(label: "AuthVC.configureWebView.BackgroundQueue", qos: .background)) { response in
                switch response.result {
                case .success(let _):
                    DispatchQueue.main.async {
                        self.webView.load(URLRequest(url: url))
                    }
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    fatalError(error.localizedDescription)
                    break;
                }
            }
    }

}

extension AuthViewController: WKNavigationDelegate {
    
    // MARK: - WKNavigationDelegate - (Optional) Method
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        guard let url: URL = webView.url else { return }
        
        //  Exchange the code for ACCESS TOKEN
        guard let code: String = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        webView.isHidden = true
        
        print("code: \(code) \n")
        
        AuthManager.shared.exchangeCodeForAccessToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct AuthViewControllerRepresentable: UIViewControllerRepresentable {

    // MARK: - UIViewControllerRepresentable - (Required) Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {

        AuthViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct AuthViewControllerRepresentable_PreviewProvider: PreviewProvider {

    static var previews: some View {

        Group {
            AuthViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
