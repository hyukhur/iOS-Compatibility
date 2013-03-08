//
//  HHOrderedSet.m
//  HHCompatibility
//
//  Created by hyukhur on 13. 2. 16..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import "HHOrderedSet.h"

@implementation HHOrderedSet

//- (NSUInteger)count;
//- (id)objectAtIndex:(NSUInteger)idx;
//- (NSUInteger)indexOfObject:(id)object;

@end

@implementation HHOrderedSet (NSExtendedOrderedSet)

//- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range;
//- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes;
//- (id)firstObject;
//- (id)lastObject;
//
//- (BOOL)isEqualToOrderedSet:(NSOrderedSet *)other;
//
//- (BOOL)containsObject:(id)object;
//- (BOOL)intersectsOrderedSet:(NSOrderedSet *)other;
//- (BOOL)intersectsSet:(NSSet *)set;
//
//- (BOOL)isSubsetOfOrderedSet:(NSOrderedSet *)other;
//- (BOOL)isSubsetOfSet:(NSSet *)set;
//
//- (id)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);
//
//- (NSEnumerator *)objectEnumerator;
//- (NSEnumerator *)reverseObjectEnumerator;
//
//- (NSOrderedSet *)reversedOrderedSet;
//- (NSArray *)array;
//- (NSSet *)set;

#if NS_BLOCKS_AVAILABLE

//- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
//- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
//- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

//- (NSUInteger)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
//- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
//- (NSUInteger)indexOfObjectAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

//- (NSIndexSet *)indexesOfObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
//- (NSIndexSet *)indexesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
//- (NSIndexSet *)indexesOfObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

//- (NSUInteger)indexOfObject:(id)object inSortedRange:(NSRange)range options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp; // binary search

//- (NSArray *)sortedArrayUsingComparator:(NSComparator)cmptr;
//- (NSArray *)sortedArrayWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;

#endif

//- (NSString *)description;
//- (NSString *)descriptionWithLocale:(id)locale;
//- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;

@end

@implementation HHOrderedSet (NSOrderedSetCreation)

+ (id)orderedSet
{
    return [[super alloc] init];
}

+ (id)orderedSetWithObject:(id)object
{
    return [[self alloc] initWithObject:object];
}

+ (id)orderedSetWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    return [[self alloc] initWithObjects:objects count:cnt];
}

+ (id)orderedSetWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *argArray = [NSMutableArray array];
    va_list args;
    va_start(args, firstObj);
    for (id arg = firstObj; arg != nil; arg = va_arg(args, id))
    {
        [argArray addObject:arg];
    }
    va_end(args);
    NSRange copyRange = NSMakeRange(0, [argArray count]);
    __unsafe_unretained id *cArray = (__unsafe_unretained id *) malloc(sizeof(id *) * copyRange.length);
    [argArray getObjects:cArray range:copyRange];
    id result = [self orderedSetWithObjects:cArray count:argArray.count];
    free(cArray);
    return result;
}

+ (id)orderedSetWithOrderedSet:(NSOrderedSet *)set
{
    return [[self alloc] initWithOrderedSet:set];
}

+ (id)orderedSetWithOrderedSet:(NSOrderedSet *)set range:(NSRange)range copyItems:(BOOL)flag
{
    return [[self alloc] initWithOrderedSet:set range:range copyItems:flag];
}

+ (id)orderedSetWithArray:(NSArray *)array
{
    return [[self alloc] initWithArray:array];
}

+ (id)orderedSetWithArray:(NSArray *)array range:(NSRange)range copyItems:(BOOL)flag
{
    return [[self alloc] initWithArray:array range:range copyItems:flag];
}

+ (id)orderedSetWithSet:(NSSet *)set
{
    return [[self alloc] initWithSet:set];
}

+ (id)orderedSetWithSet:(NSSet *)set copyItems:(BOOL)flag
{
    return [[self alloc] initWithSet:set copyItems:flag];
}

- (id)initWithObject:(id)object
{
    return [super initWithObjects:object, nil];
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    return [super initWithObjects:objects count:cnt];
}

- (id)initWithObjects:(id)firstObj, ... /*NS_REQUIRES_NIL_TERMINATION*/
{
    NSMutableArray *argArray = [NSMutableArray array];
    va_list args;
    va_start(args, firstObj);
    for (id arg = firstObj; arg != nil; arg = va_arg(args, id))
    {
        [argArray addObject:arg];
    }
    va_end(args);
    NSRange copyRange = NSMakeRange(0, [argArray count]);
    __unsafe_unretained id *cArray = (__unsafe_unretained id *) malloc(sizeof(id *) * copyRange.length);
    [argArray getObjects:cArray range:copyRange];
    id result = [self initWithObjects:cArray count:copyRange.length];
    free(cArray);
    return result;
}

- (id)initWithOrderedSet:(NSOrderedSet *)set
{
    return [super initWithArray:set.array];
}

- (id)initWithOrderedSet:(NSOrderedSet *)set copyItems:(BOOL)flag
{
    return [super initWithArray:set.array copyItems:flag];
}

- (id)initWithOrderedSet:(NSOrderedSet *)set range:(NSRange)range copyItems:(BOOL)flag
{
    return [super initWithArray:[set.array subarrayWithRange:range] copyItems:flag];
}

- (id)initWithArray:(NSArray *)set range:(NSRange)range copyItems:(BOOL)flag
{
    return [super initWithArray:[set subarrayWithRange:range] copyItems:flag];
}

- (id)initWithSet:(NSSet *)set
{
    return [super initWithArray:set.allObjects];
}

- (id)initWithSet:(NSSet *)set copyItems:(BOOL)flag
{
    return [super initWithArray:set.allObjects copyItems:flag];
}

@end

/****************       Mutable Ordered Set     ****************/

@implementation HHMutableOrderedSet

//- (void)insertObject:(id)object atIndex:(NSUInteger)idx;
//- (void)removeObjectAtIndex:(NSUInteger)idx;
//- (void)replaceObjectAtIndex:(NSUInteger)idx withObject:(id)object;

@end

@implementation HHMutableOrderedSet (NSExtendedMutableOrderedSet)

//- (void)addObject:(id)object;
//- (void)addObjects:(const id [])objects count:(NSUInteger)count;
- (void)addObjectsFromArray:(NSArray *)array
{
    for (id each in array)
    {
        if (![self containsObject:each])
        {
            [self addObject:each];
        }
    }
}
//
//- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
//- (void)moveObjectsAtIndexes:(NSIndexSet *)indexes toIndex:(NSUInteger)idx;
//
//- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
//
//- (void)setObject:(id)obj atIndex:(NSUInteger)idx;
//- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);
//
//- (void)replaceObjectsInRange:(NSRange)range withObjects:(const id [])objects count:(NSUInteger)count;
//- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;
//
//- (void)removeObjectsInRange:(NSRange)range;
//- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
//- (void)removeAllObjects;
//
//- (void)removeObject:(id)object;
//- (void)removeObjectsInArray:(NSArray *)array;
//
//- (void)intersectOrderedSet:(NSOrderedSet *)other;
//- (void)minusOrderedSet:(NSOrderedSet *)other;
//- (void)unionOrderedSet:(NSOrderedSet *)other;
//
//- (void)intersectSet:(NSSet *)other;
//- (void)minusSet:(NSSet *)other;
//- (void)unionSet:(NSSet *)other;

#if NS_BLOCKS_AVAILABLE
//- (void)sortUsingComparator:(NSComparator)cmptr;
//- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
//- (void)sortRange:(NSRange)range options:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
#endif

@end

@implementation HHMutableOrderedSet (NSMutableOrderedSetCreation)

//+ (id)orderedSetWithCapacity:(NSUInteger)numItems;
//- (id)initWithCapacity:(NSUInteger)numItems;

@end