//
//  ResourcePart.swift
//  TubeSwift
//
//  Created by Leo G Dion on 4/27/15.
//  Copyright (c) 2015 Leo G Dion. All rights reserved.
//

import Foundation

public enum ResourcePart : String {
	case AuditDetails = "auditDetails",
	BrandingSettings = "brandingSettings",
	ContentDetails = "contentDetails",
	ContentOwnerDetails = "contentOwnerDetails",
	Id = "id",
	InvideoPromotion = "invideoPromotion",
	Snippet = "snippet",
	Statistics = "statistics",
	Status = "status",
	TopicDetail = "topicDetails"
}

public enum ResourceFilter {
	case ByCategory(id: String),
	ForUser(name: String),
	ById(id: String),
	ManagedByMe(managed: Bool),
	OwnedByMe(owned: Bool)
}

public struct ResourcePaging {
	public let maxResults:UInt
	public let pageToken:String
}

public struct ResourceQuery {
	public let part: ResourcePart
	public let filter: ResourceFilter
	public let paging: ResourcePaging?
	
	public init (part: ResourcePart, filter: ResourceFilter, paging: ResourcePaging? = nil) {
		self.part = part
		self.filter = filter
		self.paging = paging
	}
	
	public var parameters : [String:AnyObject] {
		var result = [String:AnyObject](minimumCapacity: 4)
		result["part"] = self.part.rawValue
		switch self.filter {
		case .ByCategory(id: let id):
			result["categoryId"] = id
		case .ById(id: let id):
			result["id"] = id
		case .ForUser(name: let name):
			result["forUsername"] = name
		case .ManagedByMe(managed: let managed):
			result["managedByMe"] = managed ? "true" : "false"
		case .OwnedByMe(owned: let owned):
			result["mine"] = owned ? "true" : "false"
		}
		if let paging = self.paging {
			result["maxResults"] = paging.maxResults
			result["pageToken"] = paging.pageToken
		}
		return result
	}
}