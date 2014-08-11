@implementation NSDictionary(CB)

- (NSString*) stringOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? nil : value;
}

- (int) intOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? 0 : [(NSNumber*) value intValue];

}

- (NSInteger) integerOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? 0 : [(NSNumber*) value integerValue];

}

- (long long) longLongOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? 0 : [(NSNumber*) value longLongValue];
}

- (double) doubleOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? 0 : [(NSNumber*) value doubleValue];

}

- (NSArray*) arrayOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? nil : value;
}

- (NSDictionary*) dictionaryOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? nil : value;
}

- (BOOL) boolOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? NO : [(NSNumber*) value boolValue];
}

/**
 * return nil if value is [NSNull null]
 */
- (id) objectOf:(id) key
{
    id value = [self objectForKey:key];
    return value == [NSNull null] ? nil : value;
}

@end
