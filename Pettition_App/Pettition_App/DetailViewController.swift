//
//  DetailViewController.swift
//  Pettition_App
//
//  Created by Alex Paramonov on 12.03.22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
     
     var webView: WKWebView!
     var detailItem: Petition?
     
     override func loadView() {
          setWebView()
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()

          setAndLoadHtml()
          
     }
     
     private func setWebView() {
          webView = WKWebView()
          view  = webView
     }
     
     private func setAndLoadHtml() {
          
          guard let detailItem = detailItem else {return}
          
          let html = """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style> body { font-size: 150%; } </style>
</head>
<body>
\(detailItem.body)
</body>
</html>
"""
          webView.loadHTMLString(html, baseURL: nil)
     }
    
}
