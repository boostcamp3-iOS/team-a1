//
//  HTMLDecodable.swift
//  tree
//
//  Created by ParkSungJoon on 10/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

protocol HTMLDecodable {
    func decode(_ html: String?) -> String?
}

extension HTMLDecodable {
    func decode(_ html: String?) -> String? {
        guard let html = html else { return nil }
        guard let data = html.data(using: .utf8) else { return nil }
        print(data)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            )
            return attributedString.string
        } catch {
            return nil
        }
    }
}
