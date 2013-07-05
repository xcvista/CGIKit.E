//
//  CGIApplication.h
//  CGIKit.E
//
//  Created by Maxthon Chan on 13-6-1.
//
//

#ifndef CGIKIT_CGIAPPLICATION_H
#define CGIKIT_CGIAPPLICATION_H

#include <CGIKit/CGICommon.h>

CGIBeginDecls

CGIClass CGIApplication;

/**
 Main entry point of an CGIKit application.
 
 @param     argc            Count of command-line arguments.
 @param     argv            Command-line argument vector.
 @param     delegateClass   Name of delegate class of
 */
CGIExtern int CGIApplicationMain(int argc, const char **argv, const char *delegateClass, const char *applicationClass) CGINoReturn;
CGIExtern id CGIApp;

CGIConstantString(CGIApplicationException, @"info.maxchan.cgikit.exception");

CGIEndDecls

#ifdef __OBJC__

@class CGIHTTPRequest, CGIHTTPResponse;

@protocol CGIApplicationDelegate <NSObject>

@optional
- (NSData *)application:(CGIApplication *)application dataFromProcessingHTTPRequest:(NSDictionary *)request requestData:(NSData *)data withResponse:(NSDictionary **)response;
- (CGIHTTPResponse *)application:(CGIApplication *)application responseFromProcessingRequest:(CGIHTTPRequest *)request;

- (void)applicationDidStart:(CGIApplication *)application;
- (void)application:(CGIApplication *)application didReceiveRequestData:(NSData *)data;
- (void)application:(CGIApplication *)application willWriteResponseHeader:(NSDictionary *)response;
- (void)application:(CGIApplication *)application willWriteResponseData:(NSData *)data;

@end

/* 
 * ====================================
 * CGIApplication
 * ------------------------------------
 * One-off classical CGI application.
 * Good for small web utilities.
 * ====================================
 */

@interface CGIApplication : NSObject

@property id<CGIApplicationDelegate> delegate;

+ (instancetype)application;

- (void)run CGINoReturn;

- (NSData *)dataFromProcessingHTTPRequest:(NSDictionary *)request requestData:(NSData *)data withResponse:(NSDictionary **)response;
- (CGIHTTPResponse *)responseFromProcessingRequest:(CGIHTTPRequest *)request;
- (void)applicationDidStart;
- (void)applicationDidReceiveRequestData:(NSData *)data;
- (void)applicationWillWriteResponseHeader:(NSDictionary *)response;
- (void)applicationWillWriteResponseData:(NSData *)data;

@end

#endif

#endif