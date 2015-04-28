//
//  TubeSwiftClient.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/27/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

public class TubeSwiftClient: NSObject {
	private static var _sharedInstance:TubeSwiftClient?
	
	public let settings:Settings
	public var oauth:OAuthClient!
	public var channels:ChannelsClient!
	internal var token:OAuthToken? {
		didSet {
			if let aToken = token {
				Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(aToken.access_token)"]
			}
		}
	}
	
	public init (settings: Settings, token: OAuthToken? = nil) {
		self.settings = settings
		super.init()
		
		self.token = token
		if let access_token = token?.access_token {
			
			Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(access_token)"]
		}
		
		self.oauth = OAuthClient(client: self)
		self.channels = ChannelsClient(client: self)
	}
	
	public static func initialize (settings: Settings, token: OAuthToken? = nil) {
		TubeSwiftClient._sharedInstance = TubeSwiftClient(settings: settings, token: token)
	}
	
	public static var sharedInstance: TubeSwiftClient {
		return self._sharedInstance!
	}
}
