//
//  HPHomeViewController.m
//  HomeProject
//
//  Created by xushuai on 10/5/15.
//
//

#import "HPHomeViewController.h"
#import "HPHomeViewModel.h"
#import "HPPhoto.h"
#import "HPImageViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "HPDetailViewController.h"

@interface HPHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) HPHomeViewModel *viewModel;

@end

@implementation HPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [HPHomeViewModel new];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel requestFirstPageImageDatasWithSuccessHandler:^{
            [self.collectionView.header endRefreshing];
            [self.collectionView reloadData];
        }];
    }];
    header.lastUpdatedTimeText = ^NSString * (NSDate *lastUpdatedTime) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        return [NSString stringWithFormat:@"Last：%@", time];;
    };
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.collectionView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.viewModel requestNextPageImageDatasWithSuccessHandler:^{
            [self.collectionView reloadData];
        }];
    }];
    footer.refreshingTitleHidden = YES;
    self.collectionView.footer = footer;
    [self.collectionView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        HPDetailViewController *vc = segue.destinationViewController;
        HPImageViewCell *cell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        vc.photo = self.viewModel.images[indexPath.row];
    }
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HPImageViewCell class]) forIndexPath:indexPath];
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(HPImageViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPPhoto *photo = self.viewModel.images[indexPath.row];
    cell.imageView.alpha = 0;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photo.url_m] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.5 animations:^{
            cell.imageView.alpha = 1;
        }];
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HPPhoto *photo = self.viewModel.images[indexPath.row];
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    if (photo.isPortrait) {
        return CGSizeMake(screenWidth / 2, screenWidth * 120 / 320.f);
    } else {
        return CGSizeMake(screenWidth, screenWidth * 120 / 320.f);
    }
}

@end
