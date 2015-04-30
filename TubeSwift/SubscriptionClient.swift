//
//  SubscriptionClient.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/29/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//


public struct SubscriptionSubscriberSnippet {
	public let title:String
	public let description:String
	public let channelId:String
	public let thumbnails:[String:Thumbnail]
	
	public init?(result:[String:AnyObject]?) {
		if let dictionary = result,
			let title = dictionary["title"] as? String,
		let description = dictionary["description"] as? String,
		let channelId = dictionary["channelId"] as? String,
			let thumbnails = Thumbnail.Set((dictionary["thumbnails"] as? [String:[String:AnyObject]])) {
				self.title = title
				self.description = description
				self.channelId = channelId
				self.thumbnails = thumbnails
		} else {
			return nil
		}
	}
}

public struct SubscriptionSnippet {
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
}

public struct Subscription {
	public let etag:String
	public let id:String
	//public let contentDetails:ContentDetails
	public let kind:YouTubeKind = YouTubeKind.Subscription
	public let subscriberSnippet:SubscriptionSubscriberSnippet?
	public let snippet:SubscriptionSnippet?
	
	public init?(result: [String:AnyObject]) {
		if let etag = result["etag"] as? String,
			let id = result["id"] as? String {
				self.etag = etag
				self.id = id
				self.subscriberSnippet = SubscriptionSubscriberSnippet(result: result["subscriberSnippet"] as? [String:AnyObject])
				self.snippet = SubscriptionSnippet(result: result["snippet"] as? [String:AnyObject])
		} else {
			return nil
		}
	}
	
}

public class SubscriptionClient: NSObject {
	public let client: TubeSwiftClient
	
	public init (client: TubeSwiftClient) {
		self.client = client
	}
	
	public func list (query: ResourceQuery, completion: (NSURLRequest, NSURLResponse?, Response<Subscription>?, NSError?) -> Void) {
		request(.GET, "https://www.googleapis.com/youtube/v3/subscriptions", parameters: query.parameters).responseJSON(options: .allZeros) { (request, response, result, error) -> Void in
			println(result)
			if let aError = error {
				completion(request, response, nil, aError)
			} else if let clRes = Response<Subscription>(kind: YouTubeKind.SubscriptionListResponse,result: result, itemFactory: {Subscription(result: $0)}) {
				completion(request, response, clRes, nil)
			} else {
				completion(request, response, nil, NSError())
			}
		}
	}
}
