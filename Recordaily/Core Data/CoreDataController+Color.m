
#import "CoreDataController+Color.h"

@implementation CoreDataController (Color)

- (Color *)colorWithName:(NSString *)name {
    
    Color *color = nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kColorKey];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"colorName = %@", name];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        
        color = [NSEntityDescription insertNewObjectForEntityForName:kColorKey
                                              inManagedObjectContext:self.managedObjectContext];
    } else if (results.count == 1) {
        
        color = results.firstObject;
        
    } else {
        
        // Error or nil or the count more than one
    }
    
    return color;
}

- (void)configureColor:(Color *)object withPropertiesInfo:(NSDictionary *)info {
    
    object.colorName  = [info objectForKey:kColorNameKey];
    object.colorRed   = [info objectForKey:kColorRedKey];
    object.colorGreen = [info objectForKey:kColorGreenKey];
    object.colorBlue  = [info objectForKey:kColorBlueKey];
    object.colorAlpha = [info objectForKey:kColorAlphaKey];
    
    [self saveContext];
}


#pragma mark ~ SEED INITIAL DATA ~

- (void)seedInitialColorData {
    
    Color *salmon = [self colorWithName:@"Salmon"];
    NSMutableDictionary *salmonPropertiesInfo = [NSMutableDictionary dictionary];
    
    [salmonPropertiesInfo setObject:@"Salmon" forKey:kColorNameKey];
    [salmonPropertiesInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:kColorRedKey];
    [salmonPropertiesInfo setObject:[NSNumber numberWithFloat:0.4f] forKey:kColorGreenKey];
    [salmonPropertiesInfo setObject:[NSNumber numberWithFloat:0.4f] forKey:kColorBlueKey];
    [salmonPropertiesInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:kColorAlphaKey];
    
    if (salmon != nil) [self configureColor:salmon withPropertiesInfo:salmonPropertiesInfo];
    
    Color *seaFoam = [self colorWithName:@"Sea Foam"];
    NSMutableDictionary *seaFoamPropertiesInfo = [NSMutableDictionary dictionary];
    
    [seaFoamPropertiesInfo setObject:@"Sea Foam" forKey:kColorNameKey];
    [seaFoamPropertiesInfo setObject:[NSNumber numberWithFloat:0.0f] forKey:kColorRedKey];
    [seaFoamPropertiesInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:kColorGreenKey];
    [seaFoamPropertiesInfo setObject:[NSNumber numberWithFloat:0.5f] forKey:kColorBlueKey];
    [seaFoamPropertiesInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:kColorAlphaKey];
    
    if (seaFoam != nil) [self configureColor:seaFoam withPropertiesInfo:seaFoamPropertiesInfo];
    
    Color *aqua = [self colorWithName:@"Aqua"];
    NSMutableDictionary *aquaPropertiesInfo = [NSMutableDictionary dictionary];
    
    [aquaPropertiesInfo setObject:@"Aqua" forKey:kColorNameKey];
    [aquaPropertiesInfo setObject:[NSNumber numberWithFloat:0.0f] forKey:kColorRedKey];
    [aquaPropertiesInfo setObject:[NSNumber numberWithFloat:0.5f] forKey:kColorGreenKey];
    [aquaPropertiesInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:kColorBlueKey];
    [aquaPropertiesInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:kColorAlphaKey];
    
    if (aqua != nil) [self configureColor:aqua withPropertiesInfo:aquaPropertiesInfo];
}

@end