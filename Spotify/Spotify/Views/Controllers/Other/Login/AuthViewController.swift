//
//  AuthViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import WebKit
import Alamofire
import SnapKit

class AuthViewController: UIViewController {
    
    // MARK: - Stored-Prop
    public var completionHandler: ((Bool) -> Void)? = nil
    
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
        view.backgroundColor = .systemBackground
        
        title = "Sign In"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        self.webView.navigationDelegate = self
        
        view.addSubview(self.webView)
        
        configureWebView()
        
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.webView.frame = view.bounds
    }
    
    private func configureWebView() -> Void {
        
        guard let url: URL = AuthManager.shared.signInURL else { return }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200 ..< 300)
            .response(queue: DispatchQueue.global(qos: .background)) { response in
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.webView.load(URLRequest(url: url))
                    }
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    break;
                }
            }
    }
    
    private func applyConstraints() -> Void {
        
        self.webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Extension ViewController
extension AuthViewController: WKNavigationDelegate {
    
    // MARK: - WKNavigationDelegate - (Optional) Method
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        guard let url: URL = webView.url else { return }
        
        //  Exchange the code for ACCESS TOKEN.
        guard let code: String = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        webView.isHidden = true
        
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
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        AuthViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct AuthViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            AuthViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
