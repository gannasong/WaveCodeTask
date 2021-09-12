//
//  ParserHelper.swift
//  WaveCodeTask
//
//  Created by SUNG HAO LIN on 2021/9/12.
//

import Foundation
import Alamofire

public final class ParserHelper {
  public static func parsePaginationFromHeader(headers: HTTPHeaders) -> (nextPage: Int, lastPage: Int) {
    guard let links = headers.value(for: "Link") else { return (1, 1) }

    do {
      let linkDic = try parseLinkToDic(links)
      let nextPage = linkDic["next"] ?? 1
      let lastPage = linkDic["last"] ?? 1
      return (nextPage, lastPage)
    } catch {
      print("Error parse pagination from header: ", error.localizedDescription)
    }
    return (1, 1)
  }

  public static func parseLinkToDic(_ links: String) throws -> [String: Int] {
    let parseLinksPattern = "\\s*,?\\s*<([^\\>]*)>\\s*;\\s*rel=\"([^\"]*)\""
    var linkDic: [String: Int] = [:]

    do {
      let linksRegex = try NSRegularExpression(pattern: parseLinksPattern, options: [.allowCommentsAndWhitespace])
      let length = (links as NSString).length
      let matches = linksRegex.matches(in: links, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: length))

      for match in matches {
          let matches = (1 ..< match.numberOfRanges).map { rangeIndex -> String in
              let range = match.range(at: rangeIndex)
              let startIndex = links.index(links.startIndex, offsetBy: range.location)
              let endIndex = links.index(links.startIndex, offsetBy: range.location + range.length)
              return String(links[startIndex ..< endIndex])
          }

          if matches.count != 2 {
            throw NSError(domain: "Error parsing links", code: -1)
          }

        let rel = matches[1]
        let page = parsePaginationNumber(url: matches[0])

        linkDic[rel] = page
      }
      return linkDic
    } catch {
      throw NSError(domain: "Error parsing links", code: -1)
    }
  }

  public static func parsePaginationNumber(url: String?) -> Int {
    guard let url = url else { return 1 }
    var page: Int = 1

    do {
      let regex: NSRegularExpression = try NSRegularExpression(pattern: "page=(\\d+)", options: [])
      let matches = regex.matches(in: url, options: [], range: NSMakeRange(0, url.count))
      for item in matches {
        let string = (url as NSString).substring(with: item.range)
        let pageString = string.split(separator: "=").map(String.init).last ?? "1"

        if let tempPageNumber = Int(pageString) {
          page = tempPageNumber
        }
      }
    } catch {
      print("Regular Expression Error: ", error.localizedDescription)
    }
    return page
  }
}
