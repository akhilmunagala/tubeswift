//
//  ChannelsClient.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/27/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

import UIKit

public let channel_url = "https://www.googleapis.com/youtube/v3/channels"
public struct ChannelResponse {
	
}
public class ChannelsClient: NSObject {
	public let client: TubeSwiftClient
	
	public init (client: TubeSwiftClient) {
		self.client = client
	}
	
	public func list (query: ResourceQuery, (NSURLRequest, NSURLResponse?, ChannelResponse?, NSError?) -> Void) {
		request(.GET, channel_url, parameters: query.parameters).responseJSON(options: .allZeros) { (request, response, result, error) -> Void in
			println(result)
		}
	}
}
