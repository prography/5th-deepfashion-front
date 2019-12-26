<br>

<br>



# 5th-deepfashion-front

## iOS

## 개발 진행 계획 
- 회원가입 시 받아야 할 데이터
    - 이메일
    - 비밀번호(비밀번호확인, 8자리이상)
    - 성별 : 남/녀
    - 선호스타일

- 탭바 메뉴버튼 종류 
    - 메뉴 순서 : 추천(메인), 옷장, 사진추가, (마이코디)리스트,  마이페이지(환경설정 포함)
- 마이페이지 
    - 메뉴 종류 : My Profile, Setting, liked, Daily Check
- 지금까지 기능들에서 날씨추천(서버?), 코디리스트만들기, 옷장 3개의 기능은 일단 목표로 하는게 어떨까?
    - 최악의 경우를 대비해서 고민해볼 필요 있음
- 데드라인은? 
    - **12월 말 까지 베타버전 배포완료**
    - 주기적으로 행아웃 / 오프라인 간 작업한 내용 공유



<br>




## 개발 현황 
- **로그인, 회원가입 인터페이스 구현 완료**
- **로그인, 회원가입 데이터 입력 기능 완료**
- **로그인, 회원가입 간 클라이언트~로컬서버 백엔드 연동 테스트 완료**
- 메인 텝바 화면 인터페이스 및 촬영/선택 이미지 세그멘테이션 분석 및 post처리 구현 진행 중
  - **사진 촬영 및 앨범실행 후 사진 선택 로직 구성 완료**
- 추후 진행 계획
1. **이미지 촬영, 앨범에서 고른다.(구현 완료)**
2. 세그멘테이션 분석이 되고 그 처리 및 분류 가 되면(딥러닝과 진행 예정)
3. 백엔드에 post로 해당 이미지를 준다.
    1. 이때 post 방법은 multipart의 form-data방식으로 해야한다. (진행 중)
    2. 포스트맨으로 이미지 보내는 방법 post -> 
    3. post 목적은 찍은 이미지를 DB저장하기위해 전달하는 것(이미지를 선택, 촬영 및 분석)이고, get 목적은 유저가 내 옷장에 뭐가 있는지 볼까(옷장에 들어갔을 때 상황) 따로 요청
4. 탭바 5개 뷰 레이아웃 및 기능 구현 (진행 중)





<br>

<br>



## 화면 구성 

<br>



### 로그인 


<div>
<img width="250" src="https://user-images.githubusercontent.com/4410021/71447151-b1bc1280-276e-11ea-910c-14d712de23b3.jpeg">
</div>

<br>

### 회원가입

<div>
<img width="250" src="https://user-images.githubusercontent.com/4410021/71447159-b385d600-276e-11ea-93d4-77e553613792.jpeg"> &nbsp;
<img width="250" src="https://user-images.githubusercontent.com/4410021/71447160-b385d600-276e-11ea-9df7-1e03084cc3f5.jpeg">
</div>
<br>



### 메인 화면

<div>
  <img width=200 src="https://user-images.githubusercontent.com/4410021/71447152-b254a900-276e-11ea-997b-3739cec7f49e.jpeg"> &nbsp;
<img width=200 src="https://user-images.githubusercontent.com/4410021/71447153-b254a900-276e-11ea-9704-c30d04124f4c.jpeg"> &nbsp;
<img width=200 src="https://user-images.githubusercontent.com/4410021/71479224-cd8aeb80-2836-11ea-8594-36207635a9f6.jpeg"> &nbsp;
<img width=200 src="https://user-images.githubusercontent.com/4410021/71479302-1d69b280-2837-11ea-82bc-81ac37ec9ff9.jpeg"> &nbsp;    
<img width=200 src="https://user-images.githubusercontent.com/4410021/71479225-cd8aeb80-2836-11ea-9ea5-b6a68ed1369a.jpeg"> &nbsp;  
<img width=200 src="https://user-images.githubusercontent.com/4410021/71479227-ce238200-2836-11ea-8db8-2541de377502.jpeg"> &nbsp;  
<img width=200 src="https://user-images.githubusercontent.com/4410021/71479229-ce238200-2836-11ea-98e0-0c3996ebe6e2.jpeg"> &nbsp;      
<img width=200 src="https://user-images.githubusercontent.com/4410021/71447156-b2ed3f80-276e-11ea-897b-acf8a5bc651d.jpeg"> &nbsp;
<img width=200 src="https://user-images.githubusercontent.com/4410021/71447157-b2ed3f80-276e-11ea-838c-94b1d36d0009.jpeg"> &nbsp;
<img width=200 src="https://user-images.githubusercontent.com/4410021/71447158-b2ed3f80-276e-11ea-8fee-1647524b0767.jpeg">
</div>

<br>

<br>
