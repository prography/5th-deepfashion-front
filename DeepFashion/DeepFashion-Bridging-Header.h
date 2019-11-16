//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath
    NS_SWIFT_NAME(init(fileAtPath:))NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (NSInteger)predictImage:(void*)imageBuffer forLabels:(NSInteger)labelCount
    NS_SWIFT_NAME(predict(image:labelCount:));

@end

NS_ASSUME_NONNULL_END
