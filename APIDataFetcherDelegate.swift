//
//  APIDataFetcherDelegate.swift
//  Excursion
//
//  Created by Ambuj Punn on 11/10/16.
//
//

import Foundation

@objc protocol APIDataFetcherDelegate {
    func didFetchData(data: Array<Any>?) -> Void
    func didReturnError(error: Error) -> Void
    @objc optional func didLoadNextPage(data: Array<Any>?) -> Void
}
