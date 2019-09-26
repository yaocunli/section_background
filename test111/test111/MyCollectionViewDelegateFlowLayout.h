//
//  MyCollectionViewDelegateFlowLayout.h
//


#ifndef MyCollectionViewDelegateFlowLayout_h
#define MyCollectionViewDelegateFlowLayout_h

@protocol MyCollectionViewDelegateFlowLayout <NSObject>
//是否需要在制定分区展示背景
- (BOOL)needDisplayBackgroundInSection:(NSInteger)section;

@end


#endif /* MyCollectionViewDelegateFlowLayout_h */
