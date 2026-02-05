//
//  WXToastView.h
//  EpicUnityBridge
//
//  Created by TAL on 2026/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXToastView : UIView
+ (void)showToastWithTitle:(NSString *)title;


+ (void)showToastWithTitle:(NSString *)title duration:(CGFloat)duration;
@end

NS_ASSUME_NONNULL_END
