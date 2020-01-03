#import "TorchModule.h"
#import <LibTorch/LibTorch.h>

using namespace std;

// MARK: - TorchModule
@implementation TorchModule {
@protected
    torch::jit::script::Module _impl;
}

// MARK: - initWithFileAtPath
- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
    self = [super init];
    if (self) {
        try {
            auto qengines = at::globalContext().supportedQEngines();
            if (std::find(qengines.begin(), qengines.end(), at::QEngine::QNNPACK) != qengines.end()) {
                at::globalContext().setQEngine(at::QEngine::QNNPACK);
            }
            _impl = torch::jit::load(filePath.UTF8String);
            _impl.eval();
        } catch (const std::exception& exception) {
            NSLog(@"%s", exception.what());
            return nil;
        }
    }
    return self;
}

// MARK: - PredictImage Method
- (NSArray<NSNumber*>*)predictImage:(void*)imageBuffer {
    try {

        at::Tensor tensor = torch::from_blob(imageBuffer, {1, 3, 224, 224}, at::kFloat);
        torch::autograd::AutoGradMode guard(false);
        at::AutoNonVariableTypeMode non_var_type_mode(true);

        // toTensor의 output이 1차원 배열로 반환된다

        auto outputTensor = _impl.forward({tensor}).toTuple(); //	.toTensor()
        torch::Tensor out1 = outputTensor->elements()[0].toTensor();
        torch::Tensor out2 = outputTensor->elements()[1].toTensor();
        torch::Tensor out3 = outputTensor->elements()[2].toTensor();
        torch::Tensor out4 = outputTensor->elements()[3].toTensor();

        // CPUFloatType -> float 타입
        vector<pair<int, double>> maxValue(4,{0,0});

        cout << "output Type 1" << endl;
        for(int i=0; i<at::size(out1,1); i++) {
            double nowValue = out1[0][i].item<double>();
            cout << nowValue << " ";
            if(maxValue[0].second < nowValue) maxValue[0] = {i, nowValue};
        }
        puts("");
        puts("");

        cout << "output Type 2" << endl;
        for(int i=0; i<at::size(out2,1); i++) {
            double nowValue = out2[0][i].item<double>();
            cout << nowValue << " ";
            if(maxValue[1].second < nowValue) maxValue[1] = {i, nowValue};
        }

        puts("");
        puts("");

        cout << "output Type 3" << endl;
        for(int i=0; i<at::size(out3,1); i++) {
            double nowValue = out3[0][i].item<double>();
            cout << nowValue << " ";
            if(maxValue[2].second < nowValue) maxValue[2] = {i, nowValue};
        }
        puts("");
        puts("");

        cout << "output Type 4" << endl;
        for(int i=0; i<at::size(out4,1); i++) {
            double nowValue = out4[0][i].item<double>();
            cout << nowValue << " ";
            if(maxValue[3].second < nowValue) maxValue[3] = {i, nowValue};
        }
        puts("");
        puts("");

        for(int i=0; i<4; i++) {
            printf("%d번째 타입 인덱스: %d, 최댓값: %lf", i, maxValue[i].first, maxValue[i].second);
            puts("");
        }

        // 집합이 있는 변수 4개의 배열
        // 1차원 배열로 {10,9,2,1} 식으로 반환받을 수 있게 처리해보기
        NSValue *aValue1 = @(maxValue[0].first);
        NSValue *aValue2 = @(maxValue[1].first);
        NSValue *aValue3 = @(maxValue[2].first);
        NSValue *aValue4 = @(maxValue[3].first);
        NSArray *persons = [NSArray arrayWithObjects:aValue1, aValue2, aValue3, aValue4, nil];

        return persons;
    } catch (const std::exception& exception) {
        NSLog(@"%s", exception.what());
    }
    return nil;
}

@end

