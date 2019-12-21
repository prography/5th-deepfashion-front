//#import "TorchModule.h"
//#import <LibTorch/LibTorch.h>
//
//// MARK: - TorchModule
//@implementation TorchModule {
// @protected
//  torch::jit::script::Module _impl;
//}
//
//// MARK: - initWithFileAtPath
//- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
//  self = [super init];
//  if (self) {
//    try {
//      auto qengines = at::globalContext().supportedQEngines();
//      if (std::find(qengines.begin(), qengines.end(), at::QEngine::QNNPACK) != qengines.end()) {
//        at::globalContext().setQEngine(at::QEngine::QNNPACK);
//      }
//      _impl = torch::jit::load(filePath.UTF8String);
//      _impl.eval();
//    } catch (const std::exception& exception) {
//      NSLog(@"%s", exception.what());
//      return nil;
//    }
//  }
//  return self;
//}
//
//// MARK: - PredictImage Method
//- (NSArray<NSNumber*>*)predictImage:(void*)imageBuffer {
//  try {
//    at::Tensor tensor = torch::from_blob(imageBuffer, {1, 3, 224, 224}, at::kFloat);
//    torch::autograd::AutoGradMode guard(false);
//    at::AutoNonVariableTypeMode non_var_type_mode(true);
//    //outputTensor에서 range slicing해주거나 floatBuffer 포인터에서 range slicing하는 방법
//    auto outputTensor = _impl.forward({tensor}).toTensor();
//    //(1)outputTensor 받아와서 여기서 range slicing하거나
//    float* floatBuffer[4];
//    floatBuffer[0] = outputTensor.data_ptr<float>(); //(2)여기에서 color range slicing  작업 필요하지 않을까 추정
//    floatBuffer[1] = outputTensor.data_ptr<float>(); //style range slicing
//    floatBuffer[2] = outputTensor.data_ptr<float>(); //season range slicing
//    floatBuffer[3] = outputTensor.data_ptr<float>(); //category range slicing
//    NSMutableArray* results = [[NSMutableArray alloc] init];
//      for(int i=0; i <4; i++){
//        for (int j = 0; j < 1000; j++) {
//           [results addObject:@(floatBuffer[i][j])];
//        }
//      }
//    return [results copy];
//  } catch (const std::exception& exception) {
//    NSLog(@"%s", exception.what());
//  }
//  return nil;
//}
//
//@end
//
