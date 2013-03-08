//
//  HHOrderedSet.h
//  HHCompatibility
//
//  Created by hyukhur on 13. 2. 16..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHOrderedSet : NSArray <NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration>

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)idx;
- (NSUInteger)indexOfObject:(id)object;

@end

@interface HHOrderedSet (NSExtendedOrderedSet)

- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range;
- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes;
- (id)firstObject;
- (id)lastObject;

- (BOOL)isEqualToOrderedSet:(NSOrderedSet *)other;

- (BOOL)containsObject:(id)object;
- (BOOL)intersectsOrderedSet:(NSOrderedSet *)other;
- (BOOL)intersectsSet:(NSSet *)set;

- (BOOL)isSubsetOfOrderedSet:(NSOrderedSet *)other;
- (BOOL)isSubsetOfSet:(NSSet *)set;

- (id)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);

- (NSEnumerator *)objectEnumerator;
- (NSEnumerator *)reverseObjectEnumerator;

- (NSOrderedSet *)reversedOrderedSet;

// These two methods return a facade object for the receiving ordered set,
// which acts like an immutable array or set (respectively).  Note that
// while you cannot mutate the ordered set through these facades, mutations
// to the original ordered set will "show through" the facade and it will
// appear to change spontaneously, since a copy of the ordered set is not
// being made.
- (NSArray *)array;
- (NSSet *)set;

#if NS_BLOCKS_AVAILABLE

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSUInteger)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSUInteger)indexOfObjectAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (NSIndexSet *)indexesOfObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSIndexSet *)indexesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSIndexSet *)indexesOfObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (NSUInteger)indexOfObject:(id)object inSortedRange:(NSRange)range options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp; // binary search

- (NSArray *)sortedArrayUsingComparator:(NSComparator)cmptr;
- (NSArray *)sortedArrayWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;

#endif

- (NSString *)description;
- (NSString *)descriptionWithLocale:(id)locale;
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;

@end

@interface HHOrderedSet (NSOrderedSetCreation)

+ (id)orderedSet;
+ (id)orderedSetWithObject:(id)object;
+ (id)orderedSetWithObjects:(const id [])objects count:(NSUInteger)cnt;
+ (id)orderedSetWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)orderedSetWithOrderedSet:(NSOrderedSet *)set;
+ (id)orderedSetWithOrderedSet:(NSOrderedSet *)set range:(NSRange)range copyItems:(BOOL)flag;
+ (id)orderedSetWithArray:(NSArray *)array;
+ (id)orderedSetWithArray:(NSArray *)array range:(NSRange)range copyItems:(BOOL)flag;
+ (id)orderedSetWithSet:(NSSet *)set;
+ (id)orderedSetWithSet:(NSSet *)set copyItems:(BOOL)flag;

- (id)initWithObject:(id)object;
- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt;
- (id)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithOrderedSet:(NSOrderedSet *)set;
- (id)initWithOrderedSet:(NSOrderedSet *)set copyItems:(BOOL)flag;
- (id)initWithOrderedSet:(NSOrderedSet *)set range:(NSRange)range copyItems:(BOOL)flag;
- (id)initWithArray:(NSArray *)array;
- (id)initWithArray:(NSArray *)set copyItems:(BOOL)flag;
- (id)initWithArray:(NSArray *)set range:(NSRange)range copyItems:(BOOL)flag;
- (id)initWithSet:(NSSet *)set;
- (id)initWithSet:(NSSet *)set copyItems:(BOOL)flag;

@end

/****************       Mutable Ordered Set     ****************/

@interface HHMutableOrderedSet : HHOrderedSet

- (void)insertObject:(id)object atIndex:(NSUInteger)idx;
- (void)removeObjectAtIndex:(NSUInteger)idx;
- (void)replaceObjectAtIndex:(NSUInteger)idx withObject:(id)object;

@end

@interface HHMutableOrderedSet (NSExtendedMutableOrderedSet)

- (void)addObject:(id)object;
- (void)addObjects:(const id [])objects count:(NSUInteger)count;
- (void)addObjectsFromArray:(NSArray *)array;

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)moveObjectsAtIndexes:(NSIndexSet *)indexes toIndex:(NSUInteger)idx;

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

- (void)setObject:(id)obj atIndex:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);

- (void)replaceObjectsInRange:(NSRange)range withObjects:(const id [])objects count:(NSUInteger)count;
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;

- (void)removeObjectsInRange:(NSRange)range;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)removeAllObjects;

- (void)removeObject:(id)object;
- (void)removeObjectsInArray:(NSArray *)array;

- (void)intersectOrderedSet:(NSOrderedSet *)other;
- (void)minusOrderedSet:(NSOrderedSet *)other;
- (void)unionOrderedSet:(NSOrderedSet *)other;

- (void)intersectSet:(NSSet *)other;
- (void)minusSet:(NSSet *)other;
- (void)unionSet:(NSSet *)other;

#if NS_BLOCKS_AVAILABLE
- (void)sortUsingComparator:(NSComparator)cmptr;
- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
- (void)sortRange:(NSRange)range options:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
#endif

@end

@interface HHMutableOrderedSet (NSMutableOrderedSetCreation)

+ (id)orderedSetWithCapacity:(NSUInteger)numItems;
- (id)initWithCapacity:(NSUInteger)numItems;

@end