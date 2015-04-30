//
//  PlaylistClient.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/29/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

let _dateFormatter = { ()->NSDateFormatter in
	let __ = NSDateFormatter()
	__.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
	return __
}()

public struct PlaylistSnippet {
	public let publishedAt:NSDate
	public let channelId: String?
	public let title: String
	public let description: String
	public let thumbnails:[String:Thumbnail]
	public let channelTitle:String?
	public let tags:[String]
	public init?(result: [String:AnyObject]?) {
		println(result)
		if let publishAtStr = result?["publishedAt"] as? String,
			let publishedAt =  _dateFormatter.dateFromString(publishAtStr),
			let title = result?["title"] as? String,
			let description = result?["description"] as? String,
			let thumbnails = Thumbnail.Set((result?["thumbnails"] as? [String:[String:AnyObject]])) {
				self.publishedAt = publishedAt
				self.channelId = result?["channelId"] as? String
				self.title = title
				self.description = description
				self.thumbnails = thumbnails
				self.channelTitle = result?["channelTitle"] as? String
				self.tags = result?["tags"] as? [String] ?? [String]()
		} else {
			return nil
		}
	}
//	"publishedAt": datetime,
//	"channelId": string,
//	"title": string,
//	"description": string,
//	"thumbnails": {
//	(key): {
//	"url": string,
//	"width": unsigned integer,
//	"height": unsigned integer
//	}
//	},
//	"channelTitle": string,
//	"tags": [
//	string
//	]
}

public struct Playlist {
	public let etag:String
	public let id:String
	//public let contentDetails:ContentDetails
	public let kind:YouTubeKind = YouTubeKind.Playlist
	public let snippet:PlaylistSnippet
	
	public init?(result: [String:AnyObject]) {
		if let etag = result["etag"] as? String,
			let id = result["id"] as? String,
			let snippet = PlaylistSnippet(result: result["snippet"] as? [String:AnyObject]) {
				self.etag = etag
				self.id = id
				self.snippet = snippet
		} else {
			return nil
		}
	}
}

public class PlaylistClient: NSObject {
	public let client: TubeSwiftClient
	
	public init (client: TubeSwiftClient) {
		self.client = client
	}
	
	public func list (query: ResourceQuery, completion: (NSURLRequest, NSURLResponse?, Response<Playlist>?, NSError?) -> Void) {
		request(.GET, "https://www.googleapis.com/youtube/v3/playlists", parameters: query.parameters).responseJSON(options: .allZeros) { (request, response, result, error) -> Void in
			println(result)
			if let aError = error {
				completion(request, response, nil, aError)
			} else if let clRes = Response<Playlist>(kind: YouTubeKind.PlaylistListResponse,result: result, itemFactory: {Playlist(result: $0)}) {
				completion(request, response, clRes, nil)
			} else {
				completion(request, response, nil, NSError())
			}
		}
	}
}
