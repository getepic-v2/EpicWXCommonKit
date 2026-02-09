//
//  TJSNativeParam+TJSPrivate.h
//  TALHybrid
//
//  Created by leev on 2020/12/17.
//

#import "TJSNativeParam.h"

@interface TJSNativeParam (THPrivate)

// 为了不对外暴露该方法，以下方法暂时使用分类定义，主类实现

- (id)initWithParams:(id)params;

- (void)setCallBackHandler:(THCallBackToJSHandler)callBackHandler;

@end
