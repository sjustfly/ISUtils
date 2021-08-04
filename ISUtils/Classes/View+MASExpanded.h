//
//  View+MASExpanded.h
//  SAX_iOS
//
//  Created by 普拉斯 on 2017/10/10.
//  Copyright © 2017年 dftc. All rights reserved.
//

#import <Masonry/Masonry.h>

// masonry 有superview
@interface MAS_VIEW (MASExpanded)

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created MASConstraints
 */
- (NSArray *)mass_makeConstraints:(void(^)(MASConstraintMaker *make, MAS_VIEW *superView))block;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASConstraints
 */
- (NSArray *)mass_updateConstraints:(void(^)(MASConstraintMaker *make, MAS_VIEW *superView))block;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASConstraints
 */
- (NSArray *)mass_remakeConstraints:(void(^)(MASConstraintMaker *make, MAS_VIEW *superView))block;


@end
