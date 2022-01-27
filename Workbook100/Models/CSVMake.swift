//
//  CSVMake.swift
//  Workbook100
//
//  Created by Eddie Char on 1/26/22.
//

import Foundation

struct CSVMake {
    static func commaSeparatedValueDataForLines(_ lines: [[String]]) -> Data {
        return lines.map { column in
            commaSeparatedValueStringForColumns(column)
        }.joined(separator: "\r\n").data(using: String.Encoding.utf8)!
    }

    private static func quoteColumn(_ column: String) -> String {
        if column.contains(",") || column.contains("\"") {
            return "\"" + column.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        else {
            return column
        }
    }

    private static func commaSeparatedValueStringForColumns(_ columns: [String]) -> String {
        return columns.map {column in
            quoteColumn(column)
        }.joined(separator: ",")
    }
}
