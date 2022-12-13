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
    var progressView: UIProgressView!
    var websites = ["apple.com", "google.com", "vk.com", "dzen.ru"]
    var selectedWebPage: String?
    
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
        
        // added elements for toolBar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // created instans of progressView
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // added two new buttons
        let goBack = UIBarButtonItem(barButtonSystemItem: .undo, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        // added toolBar
        toolbarItems = [goBack, progressButton,goForward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // aded observer
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)

        // loading main web page
        guard let host = selectedWebPage else { return }
        guard let url = URL(string: "https://" + host) else { return }
        webView.load(URLRequest(url: url))
        // allow gestures
        webView.allowsBackForwardNavigationGestures = true
    }
    // created UIAlertController
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: "It is a message", preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
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
    // added Key-Value observer for checking downloading web page progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    // added method for allowing only right websites
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        var wasAllow = false
        
        if let host = url?.host {
            print(host)
            for website in websites {
                if host.contains(website) {
                    // check and give allow
                    decisionHandler(.allow)
                    wasAllow = true
                    return
                }
            }
        }
        // give cancel
        decisionHandler(.cancel)
        // added alert if website is blocked
        if !wasAllow {
            let ac = UIAlertController(title: "Denied", message: "This website was blocked", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .destructive))

            present(ac, animated: true)
        }
    }
    

}

