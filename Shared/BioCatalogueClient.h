//
//  BioCatalogueClient.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


@interface BioCatalogueClient : NSObject {
}

+(NSURL *) baseURL;
+(NSURL *) baseURLWithUsername:(NSString *)username andPassword:(NSString *)password;
+(NSURL *) whoAmIURLWithUsername:(NSString *)username andPassword:(NSString *)password;

+(NSURL *) announcementsFeedURL;

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format;

+(BOOL) signInWithUsername:(NSString *)username withPassword:(NSString *)password;
+(void) signOutOfBioCatalogue;
+(BOOL) userIsAuthenticated;

+(NSDictionary *) documentAtPath:(NSString *)path;
+(NSDictionary *) documentAtPath:(NSString *)path withRepresentation:(NSString *)format;

+(NSDictionary *) performSearch:(NSString *)query 
                      withScope:(NSString *)scope
             withRepresentation:(NSString *)format
                           page:(NSUInteger)pageNum;

+(NSArray *) latestServices:(NSUInteger)limit;

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum;
+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum providerID:(NSUInteger)provID;
+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum submittingUserID:(NSUInteger)userID;
+(NSDictionary *) servicesForResponsibleUserID:(NSUInteger)userID;
+(NSDictionary *) servicesForFavouritingUserID:(NSUInteger)userID;

+(NSDictionary *) monitoringStatusesForServiceWithID:(NSUInteger)serviceID;

+(NSDictionary *) providers:(NSUInteger)limit page:(NSUInteger)pageNum;

@end
