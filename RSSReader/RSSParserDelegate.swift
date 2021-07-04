//
//  RSSParserDelegate.swift
//  RSSReader
//
//  Created by Sophia Wang on 2021/4/14.
//

import Foundation

class RSSParserDelegate: NSObject, XMLParserDelegate{
    var currentItem: NewsItem?
    var currentElementValue: String?
    var resultsArray = [NewsItem]()
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName == "item"{
            //start a new item
            currentItem = NewsItem()
        }else if elementName == "title"{
            currentElementValue = nil
        }else if elementName == "link"{
            currentElementValue = nil
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            if currentItem != nil{
                resultsArray.append(currentItem!)
                currentItem = nil
            }
        }else if elementName == "title"{
            currentItem?.title = currentElementValue
        }else if elementName == "link"{
            currentItem?.link = currentElementValue
        }
        currentElementValue = nil
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementValue == nil{
            currentElementValue = string
        }else{
            currentElementValue = currentElementValue! + string
        }
    }
    
    func getResult() -> [NewsItem] {
        return resultsArray
    }
}
