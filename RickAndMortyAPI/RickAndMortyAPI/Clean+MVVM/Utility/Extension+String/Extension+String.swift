//
//  Extension+String.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation

extension String {
    // function to convert the iso format date to regular date format
    func formattedDate() -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = inputDateFormatter.date(from: self) else {
            return "Date Error"
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        outputDateFormatter.locale = Locale(identifier: "en_US")
        
        return outputDateFormatter.string(from: date)
    }
}
