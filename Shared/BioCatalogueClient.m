//
//  BioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BioCatalogueClient.h"


@implementation BioCatalogueClient

static NSString *const OAuthConsumerKey = @"3W1Pq2RQ0wxlAHdt0TCQ";
static NSString *const OAuthConsumerSecret = @"7P9WEKsS50wdX5VDBr5xi3EDzEzHMcv1n0QDRhKc";

static BOOL _userIsAuthenticated;


#pragma mark -
#pragma mark URLs

+(NSURL *) baseURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BioCatalogueHostname]];
} // baseURL

+(NSURL *) baseURLWithUsername:(NSString *)username andPassword:(NSString *)password {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@@%@",
                               [username stringByAddingPercentEscapes],
                               [password stringByAddingPercentEscapes],
                               BioCatalogueHostname]];
} // baseURLWithUsername:andPassword

+(NSURL *) whoAmIURLWithUsername:(NSString *)username andPassword:(NSString *)password {
  NSURL *url = [self baseURLWithUsername:username andPassword:password];

  url = [url URLByAppendingPathComponent:@"/users/whoami"];
  url = [url URLByAppendingPathExtension:JSONFormat];
  
  return url;
} // whoAmIURLWithUsername:andPassword

+(NSURL *) announcementsFeedURL {
  NSURL *feedBase = [NSURL URLWithString:[NSString stringWithFormat:@"feed://%@", BioCatalogueHostname]];
  return [feedBase URLByAppendingPathComponent:@"announcements.atom"];
} // announcementsFeedURL

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
  NSURL *url = [NSURL URLWithString:path relativeToURL:[self baseURL]];
  
  NSString *sanitizedPath = [[url path] lowercaseString];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", [url pathExtension]] 
                                                           withString:@""];
  
  if ([url query] && format) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@?%@", sanitizedPath, format, [url query]];
  } else if ([url query]) {
    sanitizedPath = [NSString stringWithFormat:@"%@?%@", sanitizedPath, [url query]];
  } else if (format) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@", sanitizedPath, format];
  }
  
  return [NSURL URLWithString:sanitizedPath relativeToURL:[self baseURL]];
} // URLForPath:withRepresentation


#pragma mark -
#pragma mark Authentication

+(BOOL) signInWithUsername:(NSString *)username withPassword:(NSString *)password {
  NSURLRequest *request = [NSURLRequest requestWithURL:[self whoAmIURLWithUsername:username andPassword:password]
                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       timeoutInterval:APIRequestTimeout];
  
  NSError *error = nil;
  NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
  if (error) {
    [error log];
    _userIsAuthenticated = NO;
    return _userIsAuthenticated;
  }

  id userJson = [[data objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&error] objectForKey:JSONUserElement];
  if (userJson) {
    User *user = [[BioCatalogueResourceManager catalogueUser] retain];
    
    NSUInteger userID = [[[userJson objectForKey:JSONSelfElement] lastPathComponent] intValue];
    user.uniqueID = [NSNumber numberWithInt:userID];
    
    [BioCatalogueResourceManager commmitChanges];
    [user release];
    
    // store credentials in keychain
    error = nil;
    [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:AppServiceName updateExisting:YES error:&error];
    if (error) [error log];
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:LastLoggedInUserKey];

    _userIsAuthenticated = YES;
    return _userIsAuthenticated;
  } else {
    _userIsAuthenticated = NO;
    return _userIsAuthenticated;
  }
} // signInWithUsername:withPassword

+(void) signOutOfBioCatalogue {
  NSError *error = nil;
  NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoggedInUserKey];
  [SFHFKeychainUtils storeUsername:username andPassword:@"" forServiceName:AppServiceName updateExisting:YES error:&error];
  [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LastLoggedInUserKey];
  if (error) [error log];
  
  BOOL didDelete = [BioCatalogueResourceManager deleteObject:[BioCatalogueResourceManager catalogueUser]];
  if (didDelete) [BioCatalogueResourceManager commmitChanges];
  
  _userIsAuthenticated = NO;
} // signOutOfBioCatalogue

+(BOOL) userIsAuthenticated {
  return _userIsAuthenticated;
} // userIsAuthenticated


#pragma mark -
#pragma mark Web Access

+(NSDictionary *) documentAtPath:(NSString *)path withRepresentation:(NSString *)format {
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];
  
  NSError *error = nil;
  NSURLResponse *response = nil;
  
  @try {
    NSURL *url = [self URLForPath:path withRepresentation:format];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:APIRequestTimeout];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) [error log];
    
    id json = [data objectFromJSONDataWithParseOptions:JKParseOptionUnicodeNewlines|JKParseOptionStrict
                                                 error:&error];
    
    if ([json isKindOfClass:[NSDictionary class]]) {      
      if ([[json allKeys] count] == 1) {
        return [json objectForKey:[[json allKeys] lastObject]];
      } else if ([[[json allKeys] lastObject] isEqualToString:JSONErrorsElement]) {
        return nil;
      } else {
        return json;
      }
    } else if ([json isKindOfClass:[NSArray class]]) {
      return [NSDictionary dictionaryWithObject:json forKey:JSONResultsElement];
    } else {
      return nil;
    }
  } @catch (NSException * e) {
    if (error) [error log];
    [e log];

    return nil;
  } @finally {
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
  }
} // documentAtPath

+(NSDictionary *) documentAtPath:(NSString *)path {
  return [self documentAtPath:path withRepresentation:JSONFormat];
}

+(NSDictionary *) performSearch:(NSString *)query 
                      withScope:(NSString *)scope
             withRepresentation:(NSString *)format 
                           page:(NSUInteger)pageNum {
  if (![format isValidAPIRepresentation] || ![query isValidQuery]) {
    return nil;
  }
  
  if (pageNum < 1) {
    pageNum = 1;
  }
  
  NSString *pathQuery = [NSString stringWithFormat:@"?q=%@&page=%i&per_page=%i", query, pageNum, ItemsPerPage];
  if ([scope isEqualToString:ServiceResourceScope]) {
    return [self documentAtPath:[NSString stringWithFormat:@"/services%@", pathQuery]];
  } else if ([scope isEqualToString:UserResourceScope]) {
    return [self documentAtPath:[NSString stringWithFormat:@"/users%@", pathQuery]];
  } else if ([scope isEqualToString:ProviderResourceScope]) {
    return [self documentAtPath:[NSString stringWithFormat:@"/service_providers%@", pathQuery]];
  } else {
    return [self documentAtPath:[NSString stringWithFormat:@"/search%@", pathQuery]];
  }
} // performSearch:withScope:withRepresentation

+(NSArray *) latestServices:(NSUInteger)limit {
  return [[self services:limit page:1] objectForKey:JSONResultsElement];
} // latestServices

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i&page=%i", limit, pageNum]];
} // services:page

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum providerID:(NSUInteger)provID {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i&page=%i&p=[%i]", limit, pageNum, provID]];  
} // services:page:providerID

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum submittingUserID:(NSUInteger)userID {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i&page=%i&su=[%i]", limit, pageNum, userID]];  
} // services:page:submittingUserID

+(NSDictionary *) servicesForResponsibleUserID:(NSUInteger)userID {
  return [self documentAtPath:[NSString stringWithFormat:@"/users/%i/services_responsible", userID]];  
} // servicesForResponsibleUserID

+(NSDictionary *) servicesForFavouritingUserID:(NSUInteger)userID {
  return [self documentAtPath:[NSString stringWithFormat:@"/users/%i/favourites", userID]];  
} // servicesForFavouritingUserID


+(NSDictionary *) monitoringStatusesForServiceWithID:(NSUInteger)serviceID {
  return [self documentAtPath:[NSString stringWithFormat:@"/services/%i/monitoring", serviceID]];  
} // monitoringStatusesForServiceWithID

+(NSDictionary *) providers:(NSUInteger)limit page:(NSUInteger)pageNum {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/service_providers?per_page=%i&page=%i", limit, pageNum]];
} // providers:page


@end
