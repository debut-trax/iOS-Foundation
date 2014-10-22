//
// Copyright (c) 2014, Debut Trax Ltd  -  http://debut-trax.com
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of Debut Trax Ltd nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//
//  dtCoreData.m (build 1.0.3)
//
//  Core Data error handling.
//
//  Credits:
//  dtParseCodeDataErrorMessage from code at http://stackoverflow.com/a/3510918 written by Johannes Fahrenkrug on 18/08/2010
//
//  Change History:
//  1.0.0   01/03/2011      Initial Release
//  1.0.1   12/03/2011      Added a copy of the CoreDataErrors.h codes for references when debugging
//  1.0.2   05/11/2013      Updated CoreDataErrors.h references for iOS7, added Xcode 5 HeaderDoc comments
//  1.0.3   17/10/2014      Updated CoreDataErrors.h references for iOS8, cleaned up code formatting and comments for public release
//

#import "dtCoreData.h"


@implementation NSManagedObjectContext (dtCoreData)


- (void)dtHandleCriticalError:(NSError *)error comment:(NSString *)comment
{
    // Log where the error happened.
    NSLog(@"CORE DATA: Unresolved error when %@.", comment );
    
    // Log the error type.
    NSLog(@"CORE DATA: Error type is %@", [error localizedDescription]);
    
    // Log the detailed core data error information
    NSLog(@"CORE DATA: %@", [self dtParseCoreDataErrorMessage:error]);
    
    // Crash the app so it quits cleanly for the user, and the crash dump with the logs gets submitted to Apple for us to pick up.
    // Obviously these kinds of errors should never make it into production.
    abort();
}


- (NSString *)dtParseCoreDataErrorMessage:(NSError *)error
{
    if (error && [[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
        NSArray *errors = nil;
        
        // Handle both a single error and multiple errors.
        if ([error code] == NSValidationMultipleErrorsError) {
            errors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        } else {
            errors = [NSArray arrayWithObject:error];
        }

        // Parse the array of error(s).  We only create specific messages for the validation types of error, since this is where the bulk of exceptions are and it's extremely useful to know which attribute caused the exception.
        if (errors && [errors count] > 0) {
            NSString *messages = @"Error Reason(s):\n";
            
            for (NSError * error in errors) {
                NSString *entityName = [[[[error userInfo] objectForKey:@"NSValidationErrorObject"] entity] name];
                NSString *attributeName = [[error userInfo] objectForKey:@"NSValidationErrorKey"];
                NSString *msg;
                
                switch ([error code]) {
                    case NSManagedObjectValidationError:
                        msg = @"Generic validation error.";
                        break;
                    case NSValidationMissingMandatoryPropertyError:
                        msg = [NSString stringWithFormat:@"The attribute '%@' mustn't be empty.", attributeName];
                        break;
                    case NSValidationRelationshipLacksMinimumCountError:
                        msg = [NSString stringWithFormat:@"The relationship '%@' doesn't have enough entries.", attributeName];
                        break;
                    case NSValidationRelationshipExceedsMaximumCountError:
                        msg = [NSString stringWithFormat:@"The relationship '%@' has too many entries.", attributeName];
                        break;
                    case NSValidationRelationshipDeniedDeleteError:
                        msg = [NSString stringWithFormat:@"To delete, the relationship '%@' must be empty.", attributeName];
                        break;
                    case NSValidationNumberTooLargeError:
                        msg = [NSString stringWithFormat:@"The number of the attribute '%@' is too large.", attributeName];
                        break;
                    case NSValidationNumberTooSmallError:
                        msg = [NSString stringWithFormat:@"The number of the attribute '%@' is too small.", attributeName];
                        break;
                    case NSValidationDateTooLateError:
                        msg = [NSString stringWithFormat:@"The date of the attribute '%@' is too late.", attributeName];
                        break;
                    case NSValidationDateTooSoonError:
                        msg = [NSString stringWithFormat:@"The date of the attribute '%@' is too soon.", attributeName];
                        break;
                    case NSValidationInvalidDateError:
                        msg = [NSString stringWithFormat:@"The date of the attribute '%@' is invalid.", attributeName];
                        break;
                    case NSValidationStringTooLongError:
                        msg = [NSString stringWithFormat:@"The text of the attribute '%@' is too long.", attributeName];
                        break;
                    case NSValidationStringTooShortError:
                        msg = [NSString stringWithFormat:@"The text of the attribute '%@' is too short.", attributeName];
                        break;
                    case NSValidationStringPatternMatchingError:
                        msg = [NSString stringWithFormat:@"The text of the attribute '%@' doesn't match the required pattern.", attributeName];
                        break;
                    default:
                        msg = [NSString stringWithFormat:@"Unknown error (code #%li - look in CoreDataErrors.h).", (long)[error code]];
                        break;
                }
                messages = [messages stringByAppendingFormat:@"%@%@%@\n", (entityName?:@""),(entityName?@": ":@""),msg];
            }
            // return the nicely formatted message
            return messages;
        }
    }
    // fall through
    return nil;
}



@end

/* The following list of error codes was copied from CoreDataErrors.h for iOS 8 on 17/10/2014.
   The errors marked on the left with an x have specific detailed error messages implemented.

 x NSManagedObjectValidationError                   = 1550,   // generic validation error
 x NSValidationMultipleErrorsError                  = 1560,   // generic message for error containing multiple validation errors
 x NSValidationMissingMandatoryPropertyError        = 1570,   // non-optional property with a nil value
 x NSValidationRelationshipLacksMinimumCountError   = 1580,   // to-many relationship with too few destination objects
 x NSValidationRelationshipExceedsMaximumCountError = 1590,   // bounded, to-many relationship with too many destination objects
 x NSValidationRelationshipDeniedDeleteError        = 1600,   // some relationship with NSDeleteRuleDeny is non-empty
 x NSValidationNumberTooLargeError                  = 1610,   // some numerical value is too large
 x NSValidationNumberTooSmallError                  = 1620,   // some numerical value is too small
 x NSValidationDateTooLateError                     = 1630,   // some date value is too late
 x NSValidationDateTooSoonError                     = 1640,   // some date value is too soon
 x NSValidationInvalidDateError                     = 1650,   // some date value fails to match date pattern
 x NSValidationStringTooLongError                   = 1660,   // some string value is too long
 x NSValidationStringTooShortError                  = 1670,   // some string value is too short
 x NSValidationStringPatternMatchingError           = 1680,   // some string value fails to match some pattern
 
   NSManagedObjectContextLockingError               = 132000, // can't acquire a lock in a managed object context
   NSPersistentStoreCoordinatorLockingError         = 132010, // can't acquire a lock in a persistent store coordinator
 
   NSManagedObjectReferentialIntegrityError         = 133000, // attempt to fire a fault pointing to an object that does not exist (we can see the store, we can't see the object)
   NSManagedObjectExternalRelationshipError         = 133010, // an object being saved has a relationship containing an object from another store
   NSManagedObjectMergeError                        = 133020, // merge policy failed - unable to complete merging
 
   NSPersistentStoreInvalidTypeError                = 134000, // unknown persistent store type/format/version
   NSPersistentStoreTypeMismatchError               = 134010, // returned by persistent store coordinator if a store is accessed that does not match the specified type
   NSPersistentStoreIncompatibleSchemaError         = 134020, // store returned an error for save operation (database level errors ie missing table, no permissions)
   NSPersistentStoreSaveError                       = 134030, // unclassified save error - something we depend on returned an error
   NSPersistentStoreIncompleteSaveError             = 134040, // one or more of the stores returned an error during save (stores/objects that failed will be in userInfo)
   NSPersistentStoreSaveConflictsError			    = 134050, // an unresolved merge conflict was encountered during a save.  userInfo has NSPersistentStoreSaveConflictsErrorKey
 
   NSCoreDataError                                  = 134060, // general Core Data error
   NSPersistentStoreOperationError                  = 134070, // the persistent store operation failed
   NSPersistentStoreOpenError                       = 134080, // an error occurred while attempting to open the persistent store
   NSPersistentStoreTimeoutError                    = 134090, // failed to connect to the persistent store within the specified timeout (see NSPersistentStoreTimeoutOption)
   NSPersistentStoreUnsupportedRequestTypeError	    = 134091, // an NSPersistentStore subclass was passed an NSPersistentStoreRequest that it did not understand
 
   NSPersistentStoreIncompatibleVersionHashError    = 134100, // entity version hashes incompatible with data model
   NSMigrationError                                 = 134110, // general migration error
   NSMigrationCancelledError                        = 134120, // migration failed due to manual cancellation
   NSMigrationMissingSourceModelError               = 134130, // migration failed due to missing source data model
   NSMigrationMissingMappingModelError              = 134140, // migration failed due to missing mapping model
   NSMigrationManagerSourceStoreError               = 134150, // migration failed due to a problem with the source data store
   NSMigrationManagerDestinationStoreError          = 134160, // migration failed due to a problem with the destination data store
   NSEntityMigrationPolicyError                     = 134170, // migration failed during processing of the entity migration policy
 
   NSSQLiteError                                    = 134180, // general SQLite error
 
   NSInferredMappingModelError                      = 134190, // inferred mapping model creation error
   NSExternalRecordImportError                      = 134200  // general error encountered while importing external records
 
 */













