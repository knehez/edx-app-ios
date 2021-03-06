//
//  DiscussionAPI.swift
//  edX
//
//  Created by Tang, Jeff on 6/26/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import Foundation

public enum DiscussionPostsFilter {
    case AllPosts
    case Unread
    case Unanswered
    
    private var apiRepresentation : String? {
        switch self {
        case AllPosts: return nil // default
        case Unread: return "unread"
        case Unanswered: return "unanswered"
        }
    }
}

public enum DiscussionPostsSort {
    case RecentActivity
    case LastActivityAt
    case VoteCount
    
    private var apiRepresentation : String? {
        switch self {
        case RecentActivity: return nil // default
        case LastActivityAt: return "last_activity_at"
        case VoteCount: return "vote_count"
        }
    }
}

public class DiscussionAPI {
    static func createNewThread(newThread: DiscussionNewThread) -> NetworkRequest<DiscussionThread> {
        let json = JSON([
            "course_id" : newThread.courseID,
            "topic_id" : newThread.topicID,
            "type" : newThread.type.rawValue,
            "title" : newThread.title,
            "raw_body" : newThread.rawBody,
            ])
        return NetworkRequest(
            method : HTTPMethod.POST,
            path : "/api/discussion/v1/threads/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionThread> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionThread(json: $0)
                }
        })
    }
    
    // when parent id is nil, counts as a new post
    static func createNewComment(threadID : String, text : String, parentID : String? = nil) -> NetworkRequest<DiscussionComment> {
        var json = JSON([
            "thread_id" : threadID,
            "raw_body" : text,
            ])
        
        if let parentID = parentID {
            json["parent_id"] = JSON(parentID)
        }
        
        return NetworkRequest(
            method : HTTPMethod.POST,
            path : "/api/discussion/v1/comments/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionComment> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionComment(json: $0)
                }
        })
    }
    
    // User can only vote on post and response not on comment.
    // thread is the same as post
    static func voteThread(voted: Bool, threadID: String) -> NetworkRequest<DiscussionThread> {
        let json = JSON(["voted" : !voted])
        return NetworkRequest(
            method : HTTPMethod.PATCH,
            path : "/api/discussion/v1/threads/\(threadID)/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionThread> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionThread(json: $0)
                }
        })
    }
    
    static func voteResponse(voted: Bool, responseID: String) -> NetworkRequest<DiscussionComment> {
        let json = JSON(["voted" : !voted])        
        return NetworkRequest(
            method : HTTPMethod.PATCH,
            path : "/api/discussion/v1/comments/\(responseID)/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionComment> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionComment(json: $0)
                }
        })
    }
    
    // User can flag (report) on post, response, or comment
    static func flagThread(flagged: Bool, threadID: String) -> NetworkRequest<DiscussionThread> {
        let json = JSON(["flagged" : flagged])
        return NetworkRequest(
            method : HTTPMethod.PATCH,
            path : "/api/discussion/v1/threads/\(threadID)/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionThread> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionThread(json: $0)
                }
        })
    }
    
    static func flagComment(flagged: Bool, commentID: String) -> NetworkRequest<DiscussionComment> {
        let json = JSON(["flagged" : flagged])
        return NetworkRequest(
            method : HTTPMethod.PATCH,
            path : "/api/discussion/v1/comments/\(commentID)/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionComment> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionComment(json: $0)
                }
        })
    }
   
    // User can only follow original post, not response or comment.    
    static func followThread(following: Bool, threadID: String) -> NetworkRequest<DiscussionThread> {
        var json = JSON(["following" : !following])
        return NetworkRequest(
            method : HTTPMethod.PATCH,
            path : "/api/discussion/v1/threads/\(threadID)/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionThread> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionThread(json: $0)
                }
        })
    }    
    
    
    static func markThreadAsRead(read: Bool, threadID: String) -> NetworkRequest<DiscussionThread> {
        let json = JSON(["read" : read])
        return NetworkRequest(
            method : HTTPMethod.PATCH,
            path : "/api/discussion/v1/threads/\(threadID)/",
            requiresAuth : true,
            body: RequestBody.JSONBody(json),
            deserializer : {(response, data) -> Result<DiscussionThread> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {
                    return DiscussionThread(json: $0)
                }
        })
    }
    
    static func getThreads(#courseID: String, topicID: String, filter: DiscussionPostsFilter, orderBy: DiscussionPostsSort) -> NetworkRequest<[DiscussionThread]> {
        var query = ["course_id" : JSON(courseID), "topic_id": JSON(topicID)]
        if let view = filter.apiRepresentation {
            query["view"] = JSON(view)
        }
        if let order = orderBy.apiRepresentation {
            query["order_by"] = JSON(order)
        }        
        
        return NetworkRequest(
            method : HTTPMethod.GET,
            path : "/api/discussion/v1/threads/",
            query: query,
            requiresAuth : true,
            deserializer : {(response, data) -> Result<[DiscussionThread]> in
                return Result(jsonData : data, error : NSError.oex_unknownError(), constructor: {
                    var result: [DiscussionThread] = []
                    if let threads = $0["results"].array {
                        for json in threads {
                            if let discussionThread = DiscussionThread(json: json) {
                                result.append(discussionThread)
                            }
                        }
                    }
                    return result
                })
        })
    }
    
    static func searchThreads(#courseID: String, searchText: String) -> NetworkRequest<[DiscussionThread]> {
        return NetworkRequest(
            method : HTTPMethod.GET,
            path : "/api/discussion/v1/threads/",
            query: ["course_id" : JSON(courseID), "text_search": JSON(searchText)],
            requiresAuth : true,
            deserializer : {(response, data) -> Result<[DiscussionThread]> in
                return Result(jsonData : data, error : NSError.oex_unknownError(), constructor: {
                    var result: [DiscussionThread] = []
                    if let threads = $0["results"].array {
                        for json in threads {
                            if let discussionThread = DiscussionThread(json: json) {
                                result.append(discussionThread)
                            }
                        }
                    }
                    return result
                })
        })
    }
    
    static func getResponses(threadID: String) -> NetworkRequest<[DiscussionComment]> {
        return NetworkRequest(
            method : HTTPMethod.GET,
            path : "/api/discussion/v1/comments/", // responses are treated similarly as comments
            query: ["page_size" : 20, "thread_id": JSON(threadID)],
            requiresAuth : true,
            deserializer : {(response, data) -> Result<[DiscussionComment]> in
                return Result(jsonData : data, error : NSError.oex_unknownError()) {                    
                    var result: [DiscussionComment] = []
                    if let threads = $0["results"].array {
                        for json in threads {
                            if let discussionComment = DiscussionComment(json: json) {
                                result.append(discussionComment)
                            }
                        }
                    }
                    return result
                }
        })
    }
    
    static func getCourseTopics(courseID: String) -> NetworkRequest<[DiscussionTopic]> {
        return NetworkRequest(
                method : HTTPMethod.GET,
                path : "/api/discussion/v1/course_topics/\(courseID)",
                requiresAuth : true,
                deserializer : {(response, data) -> Result<[DiscussionTopic]> in
                    return Result(jsonData : data, error : NSError.oex_unknownError()) {
                        var result: [DiscussionTopic] = []
                        let topics = ["courseware_topics", "non_courseware_topics"]
                        for topic in topics {
                            if let results = $0[topic].array {
                                for json in results {
                                    if let topic = DiscussionTopic(json: json) {
                                        result.append(topic)
                                    }
                                }
                            }
                        }
                        return result
                    }
            })
    }

}