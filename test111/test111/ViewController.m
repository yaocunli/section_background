//
//  ViewController.m
//  test111
//


#import "ViewController.h"
#import "MYCollectionViewCell.h"
#import "MyCollectionViewDelegateFlowLayout.h"
#import "ZIDINGYICollectionViewFlowLayout.h"
#import "WhiteBackView.h"

static NSString * const cellIdentifier = @"cellIdentifier";
static NSString * const whiteViewIdenfi = @"whiteViewIdenfi";
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MyCollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建collectionView
    ZIDINGYICollectionViewFlowLayout * layout = [[ZIDINGYICollectionViewFlowLayout alloc] init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    [self.collectionView registerClass:[WhiteBackView class]  forSupplementaryViewOfKind:ZIDINGYIUICollectionElementKindSectionBackground withReuseIdentifier:whiteViewIdenfi];
    [self.collectionView reloadData];
    
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,12,20,12);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (2 + section);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    CGFloat width = (UIScreen.mainScreen.bounds.size.width - 10 * 2 - 24 ) /3;
    
    return CGSizeMake(width, width);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

-(BOOL)needDisplayBackgroundInSection:(NSInteger)section
{
    if (section % 2 == 0) {
        return true;
    } else {
        return false;
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    if ([kind isEqualToString:ZIDINGYIUICollectionElementKindSectionBackground]) {
        
        WhiteBackView *backView = [collectionView dequeueReusableSupplementaryViewOfKind:ZIDINGYIUICollectionElementKindSectionBackground withReuseIdentifier:whiteViewIdenfi forIndexPath:indexPath];
     
        return backView;
        
    }
    return nil;
}

@end
