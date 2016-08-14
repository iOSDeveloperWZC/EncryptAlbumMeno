//
//  XZPhotoBrowserFlowLayout.m
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/7/30.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import "XZPhotoBrowserFlowLayout.h"
#import "XZPhotoBrowserItem.h"

@interface XZPhotoBrowserFlowLayout ()

@property (nonatomic,assign)NSUInteger columnsCount;
@property (nonatomic,strong)NSMutableArray *COLUMNSHEIGHTS;//保存所有列高度的数组
@property (nonatomic,strong)NSMutableArray *itemsAttributes;//保存所有列高度的数组

@end

@implementation XZPhotoBrowserFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    self.columnsCount = self.xzColumnsCount ? self.xzColumnsCount : 2;
    NSUInteger itemCounts = [[self collectionView] numberOfItemsInSection:0];
    self.itemsAttributes = [NSMutableArray arrayWithCapacity:itemCounts];
    
    self.COLUMNSHEIGHTS = [NSMutableArray arrayWithCapacity:self.columnsCount];
    for (NSInteger index = 0; index < self.columnsCount; index++) {
        [self.COLUMNSHEIGHTS addObject:@0];
    }
    
    for (NSUInteger index = 0; index < itemCounts; index++) {
        //找到最短列
        
        NSUInteger shtIndex = [self findShortestColumn];
        
        NSUInteger origin_x = shtIndex * ([self columnWidth] + 5) + 5;
        
        NSUInteger origin_y = [self.COLUMNSHEIGHTS[shtIndex] integerValue] + 5;
        
        NSUInteger size_width = 0;
        if (shtIndex < self.columnsCount - 1 && [self.COLUMNSHEIGHTS[shtIndex] floatValue] == [self.COLUMNSHEIGHTS[shtIndex+1] floatValue] && self.images[index].size.width >= 1.5 * self.images[index].size.height) {
            size_width = 2 * [self columnWidth];
        }else{
            size_width = [self columnWidth];
        }
        NSUInteger size_height = [self getImageHeight:self.images[index] width:size_width];
        if (size_width == 2 * [self columnWidth]) {
            self.COLUMNSHEIGHTS[shtIndex] = @(origin_y + size_height);
            self.COLUMNSHEIGHTS[shtIndex + 1] = @(origin_y + size_height);
        }else{
            self.COLUMNSHEIGHTS[shtIndex] = @(origin_y + size_height);
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(origin_x, origin_y, size_width, size_height);
        [self.itemsAttributes addObject:attributes];
    }
}

- (NSUInteger)getImageHeight:(UIImage *)image width:(NSUInteger)width
{
    float integerW = image.size.width;
    float integerH = image.size.height;
    float scale = width / integerW;
    NSNumber *number = [NSNumber numberWithFloat:scale * integerH];
    return [number unsignedIntegerValue];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.itemsAttributes;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.bounds.size;
    NSUInteger longstIndex = [self findLongestColumn];
    float columnMax = [self.COLUMNSHEIGHTS[longstIndex] floatValue];
    size.height = columnMax + 5;
    return size;
}

#pragma mark ---- public
//找出最短列
- (NSUInteger)findShortestColumn
{
    NSUInteger shortestIndex = 0;
    CGFloat shortestValue = MAXFLOAT;
    
    NSUInteger index = 0;
    for (NSNumber *columnHeight in self.COLUMNSHEIGHTS) {
        if ([columnHeight floatValue] < shortestValue) {
            shortestValue = [columnHeight floatValue];
            shortestIndex = index;
        }
        index++;
    }
    return shortestIndex;
}

- (NSUInteger)findLongestColumn
{
    NSUInteger longestIndex = 0;
    CGFloat longestValue = 0;
    
    NSUInteger index = 0;
    for (NSNumber *columnHeight in self.COLUMNSHEIGHTS) {
        if ([columnHeight floatValue] > longestValue) {
            longestValue = [columnHeight floatValue];
            longestIndex = index;
        }
        index++;
    }
    return longestIndex;
}

- (float)columnWidth
{
    return roundf((self.collectionView.bounds.size.width - (self.columnsCount + 1) * 5) / self.columnsCount);
}

@end
