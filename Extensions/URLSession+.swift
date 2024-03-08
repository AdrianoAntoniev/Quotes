//
//  URLSession+.swift
//  Jokes
//
//  Created by Adriano Rodrigues Vieira on 12/02/24.
//

import Foundation

extension URLSession {
    func dataTask(
        with request: URLRequest,
        printingJson printJson: Bool,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {

        let handler: ((Data?, URLResponse?, Error?) -> Void) = { data, response, error in
            if printJson, let data, let json = data.prettyPrintedJSONString as? String {
                print(json)
            }
            completionHandler(data, response, error)
        }

        return dataTask(with: request, completionHandler: handler)
    }
}
