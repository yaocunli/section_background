//
//  ZIDINGYICollectionViewFlowLayout.h
//


#import <UIKit/UIKit.h>
#import "MyCollectionViewDelegateFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

// 背景supplementaryView的elementKind
UIKIT_EXTERN NSString *const ZIDINGYIUICollectionElementKindSectionBackground;

@interface ZIDINGYICollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<MyCollectionViewDelegateFlowLayout> delegate;

@end

NS_ASSUME_NONNULL_END
