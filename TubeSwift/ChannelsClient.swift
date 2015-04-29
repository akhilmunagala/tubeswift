//
//  ChannelsClient.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/27/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

import UIKit

public let channel_url = "https://www.googleapis.com/youtube/v3/channels"

public enum YouTubeKind:String {
	case ChannelListResponse = "youtube#channelListResponse"
	case Channel = "youtube#channel"
}

public struct RelatedPlaylists {
	public let favoritesId:String
	public let likesId:String
	public let uploadsId:String
	public let watchHistoryId:String
	public let watchLaterId:String
}

public struct ContentDetails {
	public let googlePlusUserId:String
	public let relatedPlaylists:RelatedPlaylists
}

public struct Channel {
	public let eTag:String
	public let id:String
	public let contentDetails:ContentDetails
	public let kind:YouTubeKind = YouTubeKind.Channel
	
	public init?(result: [String:AnyObject]) {
		return nil
	}
}

public struct PageInfo {
	public let resultsPerPage:Int
	public let totalResults:Int
	
	public init?(result : AnyObject?) {
		return nil
	}
}

public struct ChannelListResponse {
	public let eTag:String
	public let kind:YouTubeKind = YouTubeKind.ChannelListResponse
	public let items:[Channel]
	public let prevPageToken:String?
	public let nextPageToken:String?
	public let pageInfo:PageInfo
	
	public init?(result: AnyObject?) {
		if let dictionary = result as? [String:AnyObject],
			let eTag = dictionary["etag"] as? String,
			let pageInfo = PageInfo(result:dictionary["pageInfo"]),
			let itemObjs = (dictionary["items"] as? [[String:AnyObject]]){
				var items = [Channel]()
				for obj in itemObjs {
					if let channel = Channel(result: obj) {
						items.append(channel)
					} else {
						return nil
					}
				}
				self.eTag = eTag
				self.pageInfo = pageInfo
				self.items = items
				return nil
		}
		return nil
	}
}

public class ChannelsClient: NSObject {
	public let client: TubeSwiftClient
	
	public init (client: TubeSwiftClient) {
		self.client = client
	}
	
	public func list (query: ResourceQuery, completion: (NSURLRequest, NSURLResponse?, ChannelListResponse?, NSError?) -> Void) {
		request(.GET, channel_url, parameters: query.parameters).responseJSON(options: .allZeros) { (request, response, result, error) -> Void in
			if let aError = error {
				completion(request, response, nil, aError)
			} else if let clRes = ChannelListResponse(result: result) {
				completion(request, response, clRes, nil)
			} else {
				completion(request, response, nil, NSError())
			}
		}
	}
}
