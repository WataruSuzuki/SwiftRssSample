//
//  RssHelper.swift
//  SwiftRssSample
//
//  Created by WataruSuzuki on 2016/11/25.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

struct CatWho {
    public static let rssUrl = "http://thecat.jp/?xml"
    public static let cutTitleIndex = 10
    public static let cutDescriptionIndex = 30
    public static let keyTitle = "title"
    public static let keyLink = "link"
    public static let keyDescription = "description"
    
    public static let cutKeywords = [
        "\n"
    ]
    
}

class RssHelper: NSObject,
    XMLParserDelegate
{
    var rssObj = [Dictionary<String, String>]()
    var elementParse = ""
    var didEndParse:(() -> Void)?

    func loadRss(urlStr: String) {
        let task = URLSession.shared.dataTask(with: URL(string: CatWho.rssUrl)!) { (data, response, error) in
            if let data = data {
                let parser = XMLParser(data: data)
                print(parser)
                parser.delegate = self;
                parser.parse()
            }
        }
        task.resume()
    }
    
    func cutTitleStr(text: String) -> String {
        return generateText(oldStr: text, cutIndex: CatWho.cutTitleIndex)
    }
    
    func cutDescriptionStr(text: String) -> String {
        let striped = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return generateText(oldStr: striped, cutIndex: CatWho.cutDescriptionIndex)
    }
    
    func generateText(oldStr: String, cutIndex: Int) -> String {
        var newStr = oldStr
        
        for keyword in CatWho.cutKeywords {
            newStr = newStr.replacingOccurrences(of: keyword, with: "")
        }
        
        if newStr.characters.count >= cutIndex {
            let index = newStr.index(newStr.startIndex, offsetBy: cutIndex)
            newStr = newStr.substring(to: index)
        }
        
        return newStr
    }
    
    // MARK: - NSXMLParserDelegate
    func parserDidStartDocument(_ parser: XMLParser) {
        //do nothing
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.didEndParse?()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        switch elementName {
        case "item":
            rssObj.append([CatWho.keyTitle: "", CatWho.keyLink: "", CatWho.keyDescription: ""])
            
        default:
            elementParse = elementName
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if rssObj.count > 0 {
            switch elementParse {
            case CatWho.keyTitle:fallthrough
            case CatWho.keyLink:fallthrough
            case CatWho.keyDescription:
                if let prevStr = rssObj[rssObj.count - 1][elementParse] {
                    rssObj[rssObj.count - 1][elementParse] = prevStr + string
                } else {
                    rssObj[rssObj.count - 1][elementParse] = string
                }
                
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        elementParse = ""
    }
}
