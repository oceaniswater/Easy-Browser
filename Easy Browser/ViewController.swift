//
//  ViewController.swift
//  Easy Browser
//
//  Created by Марк Голубев on 12.12.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    // created webview before viewDidLoad()
    override func loadView() {
        webView = WKWebView()
        // delegate
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // added navigationItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        // loading web page
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        // allow gestures
        webView.allowsBackForwardNavigationGestures = true
    }
    // created UIAlertController
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: "It is a message", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // special row for iPad
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // func for loading web page from UIAlertController
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    // added title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

}

