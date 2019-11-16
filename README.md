# 5th-deepfashion-front

## iOS

## 개발 진행 계획 
- 회원가입 시 받아야 할 데이터
    - 이메일
    - 비밀번호(비밀번호확인, 8자리이상)
    - 성별 : 남/녀
    - 선호스타일

- 탭바 메뉴버튼 종류 
    - 메뉴 순서 : 추천(메인), 옷장, 사진추가, (마이코디)리스트,  마이페이지(설정 포함)
- 마이페이지 
    - 메뉴 종류 : My Profile, Setting, liked, Daily Check
- 지금까지 기능들에서 날씨추천(서버?), 코디리스트만들기, 옷장 3개의 기능은 일단 목표로 하는게 어떨까?
    - 최악의 경우를 대비해서 고민해볼 필요 있음
- 데드라인은? 
    - 시작 : 나랑 동주는 회원가입부터 구현, ~11/8일 까지!
    - 1차구현을 1달 목표로 
    - 주기적으로 작업한 내용 공유


## 개발 현황 
- 로그인, 회원가입 인터페이스 구현 완료
- 로그인, 회원가입 데이터 입력 기능 완료
- **로그인, 회원가입 간 클라이언트~로컬서버 백엔드 연동 테스트 완료**
- 메인 텝바 화면 인터페이스 및 촬영/선택 이미지 세그멘테이션 분석 및 post처리 구현 진행 중
  - 사진 촬영 및 앨범실행 후 사진 선택 로직 구성 완료
- 추후 진행 계획
1. 이미지 촬영, 앨범에서 고른다.(구현)
2. 세그멘테이션 분석이 되고 그 처리 및 분류 가 되면(딥러닝과 추후 진행 예정)
3. 백엔드에 post로 해당 이미지를 준다.
    1. 이때 post 방법은 multipart의 form-data방식으로 해야한다. (알아내야함) -> 주중에 테스트 해줘야 함 
    2. 포스트맨으로 이미지 보내는 방법 post -> 
    3. post 목적은 찍은 이미지를 DB저장하기위해 전달하는 것(이미지를 선택, 촬영 및 분석)이고, get 목적은 유저가 내 옷장에 뭐가 있는지 볼까(옷장에 들어갔을 때 상황) 따로 요청

  
<div>
<img width="250" src="https://user-images.githubusercontent.com/4410021/68251803-3770eb00-0067-11ea-90c1-42aaff71efa9.png"> &nbsp;
<img width="250" src="https://user-images.githubusercontent.com/4410021/68251807-3c359f00-0067-11ea-9e74-2e24ce529f60.png">
</div>

<br>

<div>
<img width="250" src="https://user-images.githubusercontent.com/4410021/68251810-3dff6280-0067-11ea-941e-0ab7e4d82585.png"> &nbsp;
<img width="250" src="https://user-images.githubusercontent.com/4410021/68251814-3fc92600-0067-11ea-83bd-eba3669e8e93.png">
</div>
<br>

<div>
<img width="250" src="https://user-images.githubusercontent.com/4410021/68989973-c7493d00-0890-11ea-8bcb-69b33123f603.png"> &nbsp;
<img width="250" src="https://user-images.githubusercontent.com/4410021/68989974-c7493d00-0890-11ea-8348-129c8d7c194c.png">
</div>
