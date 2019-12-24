//#import "TorchModule.h"
//#import <LibTorch/LibTorch.h>
//
//// MARK: - TorchModule
//@implementation TorchModule {
//@protected
//    torch::jit::script::Module _impl;
//}
//
//// MARK: - initWithFileAtPath
//- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
//    self = [super init];
//    if (self) {
//        try {
//            auto qengines = at::globalContext().supportedQEngines();
//            if (std::find(qengines.begin(), qengines.end(), at::QEngine::QNNPACK) != qengines.end()) {
//                at::globalContext().setQEngine(at::QEngine::QNNPACK);
//            }
//            _impl = torch::jit::load(filePath.UTF8String);
//            _impl.eval();
//        } catch (const std::exception& exception) {
//            NSLog(@"%s", exception.what());
//            return nil;
//        }
//    }
//    return self;
//}
//
//// MARK: - PredictImage Method
//- (NSArray<NSNumber*>*)predictImage:(void*)imageBuffer {
//    try {
//        at::Tensor tensor = torch::from_blob(imageBuffer, {1, 3, 224, 224}, at::kFloat);
//        torch::autograd::AutoGradMode guard(false);
//        at::AutoNonVariableTypeMode non_var_type_mode(true);
//        
//        // toTensor의 output이 1차원 배열로 반환된다
//        
//        
//        auto outputTensor = _impl.forward({tensor}).toTensorList(); //	.toTensor()
////        float* floatBuffer = outputTensor.data_ptr<float>();
////        NSMutableArray* results = [[NSMutableArray alloc] init];
////        for (int i = 0; i < 1000; i++) {
////            [results addObject:@(floatBuffer[i])];
////        }
////        at::Tensor output = _impl.forward({tensor}).toTensor();
//        
////        std::cout << output.slice(/*dim=*/1, /*start=*/0, /*end=*/5) << '\n';
//        // 집합이 있는 변수 4개의 배열
//        return {0};
//    } catch (const std::exception& exception) {
//        NSLog(@"%s", exception.what());
//    }
//    return nil;
//}
//
//@end
//
