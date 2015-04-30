//
//  Thumbnail.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/29/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

public struct Thumbnail {
	public let size:CGSize?
	public let url:String
	
	public static func Set (dictionary: [String: [String:AnyObject]]?) -> [String:Thumbnail]? {

		if let aDict = dictionary {
			var result = [String:Thumbnail](minimumCapacity: aDict.count)
			for (key, value) in aDict {
				if let thumbnail = Thumbnail(dictionary: value) {
					result[key] = thumbnail
				} else {
					return nil
				}
			}
			return result
		} else {
			return nil
		}
	}
	
	public init?(dictionary: [String: AnyObject]) {
		if let url = dictionary["url"] as? String {
			if let width = dictionary["width"] as? Int,
				let height = dictionary["height"] as? Int {
				self.size = CGSize(width: width, height: height)
			} else {
				self.size = nil
			}
			self.url = url
		} else {
			return nil
		}
	}
}
