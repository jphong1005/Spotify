# Spotify-clone

## 🎯 About
**Code-base 기반의 (Programmatically) UIKit Framework를 이용한 Spotify clone App 입니다.**

<br>

## 🚀 Technologies
- Swift (version 5.9)
- Xcode (version 15.0.1)
- UIKit Framework
- AutoLayout
- Spotify Web API
- SnapKit (version 5.6.0)
- Almofire
- KeychainAccess (version 4.2.2)
- RxSwift, RxCocoa (version 6.5.0)
- SDWebImage
- Then (version 3.0.0)
- SwiftSoup

<br>

## ✅ Requirements
**STEP 1. 먼저 터미널에서 아래 명령어로 프로젝트를 클론해주세요.**
```
# Clone this project

$ git clone https://github.com/jphong1005/Spotify.git
```

**STEP 2. [Spotify Developer](https://developer.spotify.com) 사이트에 로그인을 해주세요.**

-> `Spotify 계정이 없으시다면 먼저 계정을 만들어주세요.`
> ⚠️ **단, Google, Facebook, Apple과 같은 소셜로그인이 아닌 반드시 '이메일 주소'를 이용하여 일반계정으로 생성해주세요**
> 
> 이 앱은 소셜 로그인 기능을 지원하지 않습니다. 😢

**STEP 3. 앱을 사용하기 위해서 Spotify Developer에서 제공하는 [Getting started with Web API](https://developer.spotify.com/documentation/web-api/tutorials/getting-started#create-an-app) 문서를 참조하여 아래 이미지처럼 앱을 만들어주세요.**

<img width="50%" height="50%" alt="스크린샷 2023-11-11 18 14 42" src="https://github.com/jphong1005/Spotify/assets/52193695/f6412bbb-6047-44b7-b163-31f136bf2d19">

**STEP 4. 아래 이미지처럼 추가정보를 입력하여 앱을 완성시켜줍니다.**

Dashboard > Spotify > Settings로 이동하여

|<img width="100%" alt="스크린샷 2023-11-11 18 25 10" src="https://github.com/jphong1005/Spotify/assets/52193695/d0888366-0446-4078-a57c-cab86dee6a0a">|<img width="1130" alt="스크린샷 2023-11-11 18 26 14" src="https://github.com/jphong1005/Spotify/assets/52193695/ef872031-e392-4498-a308-b9e0c1096c71">|
|:---:|:---:|

Bundle IDs와 User Management를 추가해줍니다.

**STEP 5. 터미널에서 프로젝트의 Podfile파일이 있는 경로에서 아래의 명령어로 pods를 설치해줍니다.**
```
$ pod install
```

**STEP 6. Xcode에서 .xcworkspace파일로 프로젝트를 열고, .xcconfig 파일을 생성하여 아래와 같이 작성해줍니다.**

`Spotify Developer에서 제공하는 Client_ID, Client_secret와 같은 민감한 정보는 별도의 .xcconfig파일로 분리시켰으나 .gitignore 파일에 저장해두었기에 따로 올리지는 않습니다.`

```swift
#include "Pods/Target Support Files/Pods-Spotify/Pods-Spotify.debug.xcconfig"

Spotify_Client_ID = <Your Client_ID>
Spotify_Client_secret = <Your Client_secret>
```

<br>

## 📱 Results
|<img src="https://github.com/jphong1005/Spotify/assets/52193695/564633ce-5040-4ec1-b066-5d5bd2af6fb9"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/55a1b045-7b35-4324-9f05-05f9739dbf6e"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/187fc8c8-99b7-4070-aebf-3528f729c5af"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/43329705-98ce-4474-93bb-84637f738d38"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/3ecd289d-9d0e-49f5-9454-d5fe2d332c4e"></img>
|:---:|:---:|:---:|:---:|:---:|
|`로그인 기능`|`메인 뷰`|`플레이리스트 뷰`|`플레이어 뷰`|`장르 및 검색 뷰`|

|<img src="https://github.com/jphong1005/Spotify/assets/52193695/f5a7c600-5eb3-4d11-8691-57508bf5ca9d"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/74fab494-ff3f-4e9f-8c3a-27f5cde168a1"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/4959a061-e5ba-4a5d-80c9-8daeec032933"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/972e0f47-2d24-479d-9525-74dcf69de061"></img>|<img src="https://github.com/jphong1005/Spotify/assets/52193695/cdb1e340-e203-438d-bfc6-9c51fcf8591d"></img>|
|:---:|:---:|:---:|:---:|:---:|
|`라이브러리 뷰 (플레이리스트 생성)`|`플레이리스트 곡 저장`|`플레이리스트의 모든 곡 실행`|`라이브러리 뷰 (앨범 트랙 저장)`|`공유 기능`|
