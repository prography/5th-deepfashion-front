//#import "TorchModule.h"
//#import <LibTorch/LibTorch.h>
//
//using namespace std;
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
//        
//        at::Tensor tensor = torch::from_blob(imageBuffer, {1, 3, 224, 224}, at::kFloat);
//        torch::autograd::AutoGradMode guard(false);
//        at::AutoNonVariableTypeMode non_var_type_mode(true);
//        
//        // toTensor의 output이 1차원 배열로 반환된다
//        
//        vector<torch::Tensor> inputs;
//        auto outputTensor = _impl.forward({tensor}).toTuple(); //	.toTensor()
//        torch::Tensor out1 = outputTensor->elements()[0].toTensor();
//        torch::Tensor out2 = outputTensor->elements()[1].toTensor();
//        torch::Tensor out3 = outputTensor->elements()[2].toTensor();
//        torch::Tensor out4 = outputTensor->elements()[3].toTensor();
//        
//        cout<<"out1Size : " << at::size(out1,1)<<endl;
//        cout<<"out2Size : " << at::size(out2,1)<<endl;
//        cout<<"out3Size : " << at::size(out3,1)<<endl;
//        cout<<"out4Size : " << at::size(out4,1)<<endl;
//
//        // CPUFloatType -> float 타입
//        cout << out1[0][0] << endl;
//        cout << out1[0][1] << endl;
//        cout << out1[0][2] << endl;
//
////        for(int i=0; i<at::size(out1,1); i++) {
////            cout << i << ":" << out1[i] << endl;
////        }
//        
//        puts("");
//        inputs.push_back(out1);
//        inputs.push_back(out2);
//        inputs.push_back(out3);
//        inputs.push_back(out4);
//        
//        cout<<out1<<endl;
//        cout<<out2<<endl;
//        cout<<out3<<endl;
//        cout<<out4<<endl;
//
////        float* floatBuffer = outputTensor.data_ptr<float>();
////        NSMutableArray* results = [[NSMutableArray alloc] init];
////        for (int i = 0; i < 1000; i++) {
////            [results addObject:@(floatBuffer[i])];
////        }
//
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
