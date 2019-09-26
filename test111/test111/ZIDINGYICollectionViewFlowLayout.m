//
//  ZIDINGYICollectionViewFlowLayout.m
//


#import "ZIDINGYICollectionViewFlowLayout.h"

NSString *const ZIDINGYIUICollectionElementKindSectionBackground = @"elementKindSectionViewBackGround";

NSInteger CollectionBackZIndex = -1;

@interface ZIDINGYICollectionViewFlowLayout()
@property (nonatomic, strong) NSMutableDictionary * sectionBackgroundAttributesDictionary;
@end

@implementation ZIDINGYICollectionViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.sectionBackgroundAttributesDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self generateBackgroundLayoutAttributesInfo];
}

- (void)generateBackgroundLayoutAttributesInfo {
    [self.sectionBackgroundAttributesDictionary removeAllObjects];
    
    if (!(self.delegate && [self.delegate respondsToSelector:@selector(needDisplayBackgroundInSection:)])) {
        return;
    }
    
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    if (![dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return;
    }
    NSInteger numberOfSection = [dataSource numberOfSectionsInCollectionView:self.collectionView];
    
    if (numberOfSection <= 0) {
        return;
    }
    id<UICollectionViewDelegateFlowLayout> flowLayoutDelegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    for (NSInteger i = 0; i < numberOfSection; i++) {
        if (![self.delegate needDisplayBackgroundInSection:i]) {
            continue;
        }
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        UICollectionViewLayoutAttributes * firstItem;
        if ([flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            CGSize size = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:i];
            // 没有header,取第一个item
            if (size.height == 0) {
                if ([self.collectionView numberOfItemsInSection:i] > 0) {
                    firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                }
            }else {
                // 有header，取到Header
                firstItem = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
            }
        }
        
        UICollectionViewLayoutAttributes * lastItem;
        if ([flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            CGSize size = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:i];
            // 没有footer，最后一个item
            if (size.height == 0) {
                if ([self.collectionView numberOfItemsInSection:i] > 0)
                    lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:itemCount - 1 inSection:i]];
            }
        }else {
            // 有footer取footer
            lastItem = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        }
        
        UIEdgeInsets sectionInset = self.sectionInset;
        // 取insetForSection的值
        if ([flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [flowLayoutDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:i];
        }
        CGRect sectionFrame;
        if (firstItem && lastItem) {
            sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
        }else if (firstItem) {
            sectionFrame = firstItem.frame;
        }else if (lastItem) {
            sectionFrame = lastItem.frame;
        }else {
            return;
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            BOOL hasHeader = [firstItem.representedElementKind isEqualToString:UICollectionElementKindSectionHeader];
            sectionFrame.origin.x = 0;
            sectionFrame.origin.y = hasHeader ? sectionFrame.origin.y : sectionFrame.origin.y - sectionInset.top;
            sectionFrame.size.width = self.collectionView.frame.size.width;
            sectionFrame.size.height = hasHeader ? sectionFrame.size.height : sectionFrame.size.height + sectionInset.top + sectionInset.bottom;
        }else {
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y = 0;
            sectionFrame.size.width += sectionInset.left + sectionInset.right;
            sectionFrame.size.height = self.collectionView.frame.size.height;
        }
        
        UICollectionViewLayoutAttributes * att = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:ZIDINGYIUICollectionElementKindSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        att.frame = sectionFrame;
        att.zIndex = CollectionBackZIndex;
        [self.sectionBackgroundAttributesDictionary setObject:att forKey:@(i)];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * originAttrArray = [super layoutAttributesForElementsInRect:rect];
    
    if (self.sectionBackgroundAttributesDictionary.count <= 0) {
        return originAttrArray;
    }
    if (!(self.delegate && [self.delegate respondsToSelector:@selector(needDisplayBackgroundInSection:)])) {
        return originAttrArray;
    }
    // super中layoutAttributes的可变拷贝
    NSMutableArray * mOriginAttrArray = [originAttrArray mutableCopy];
    // 已经加入的背景attributes的字典，用来去重
    NSMutableDictionary * hasAddBackAttrDictionary = [NSMutableDictionary dictionary];

    for (NSInteger i = 0; i < originAttrArray.count; i++) {
        UICollectionViewLayoutAttributes * originAttr = originAttrArray[i];
        // 布局对象的section不需要展示background就不添加
        if (![self.delegate needDisplayBackgroundInSection: originAttr.indexPath.section]) {
            continue;
        }
        // 布局对象是sectionHeader或者分区的第一个cell时，将该分区的背景布局对象添加到返回的数组中去
        if ([originAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] || (originAttr.representedElementKind == nil && originAttr.indexPath.item == 0)) {
            UICollectionViewLayoutAttributes * backAtt = [self layoutAttributesForSupplementaryViewOfKind:ZIDINGYIUICollectionElementKindSectionBackground atIndexPath:originAttr.indexPath];
            // 如果这个背景布局对象没有被加入统计字典中，就加入统计字典(去重，防止头跟第一个cell都加了一遍)，并加入返回的布局对象数组中
            NSString * sectionKey = [NSString stringWithFormat:@"%@", @(originAttr.indexPath.section)];
            if (!hasAddBackAttrDictionary[sectionKey] && backAtt) {
                [hasAddBackAttrDictionary setObject:backAtt forKey:sectionKey];
                [mOriginAttrArray addObject:backAtt];
            }
        }
    }
    return mOriginAttrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:ZIDINGYIUICollectionElementKindSectionBackground]) {
        return self.sectionBackgroundAttributesDictionary[@(indexPath.section)];
    }else {
        UICollectionViewLayoutAttributes * attr = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
        return attr;
    }
}



@end
