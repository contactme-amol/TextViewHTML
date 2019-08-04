//
//  ViewController.swift
//  TextViewDemo
//
//  Created by Amol Chaudhari on 03/08/19.
//  Copyright © 2019 POC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showHTMLContentInTextView()
    }
    
    private func showHTMLContentInTextView() {
        let html = getHtmlTextFromJSONFile()
        let htmlAttributed = getAttributedString(html: html)
        textView.attributedText = htmlAttributed
        let height = getContentHeight(attributedText: htmlAttributed)
        textViewHeight.constant = height
    }
    
    
    private func getHtmlTextFromJSONFile() -> String {
        if let path = Bundle.main.path(forResource: "json", ofType: "geojson") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let result = try JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)
                let body = (result as! Dictionary)["Body"] ?? "" as String
                return body
            } catch let exception {
                print("Expection of parsing \(exception.localizedDescription)")
            }
        }
        
        return ""
    }
    
    private func getAttributedString(html: String) -> NSAttributedString {
        let htmlData = NSString(string: html).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                              options: options,
                                                              documentAttributes: nil)
        
        return attributedString ?? NSAttributedString()
    }
    
    private func getContentHeight(attributedText: NSAttributedString) -> CGFloat {
        let size = CGSize(width: textView.frame.width, height: view.frame.height)
        let boundingBox = attributedText.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics],
            context: nil
        )
        print(boundingBox.height)
        return boundingBox.height
    }
}

