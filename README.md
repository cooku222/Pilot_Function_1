# 🧭 용인시 노인 길안내 어플리케이션 - Pilot Function 1 (경로 안내)

> 본 프로젝트는 **용인시 고령층을 위한 길안내 어플리케이션**의 기능 1(Pilot 1)을 구현한 Flutter 앱입니다.  
> **Tmap API**를 사용해 출발지-도착지 간 **경로 탐색 및 안내 기능**을 제공합니다.

---

## 🛠️ 기술 스택

- **Framework**: Flutter
- **Language**: Dart
- **지도 API**: Tmap API
- **주요 기능**: 경로 탐색, 지도 출력, 실시간 경로 안내

---

## 🧩 주요 기능

- ✅ 출발지 및 목적지 입력 UI
- ✅ Tmap API를 통한 경로 탐색
- ✅ 지도 상 경로 시각화
- ✅ Flutter 위젯 기반 실시간 안내 구성

---

## 📁 디렉토리 구조

```plaintext
.
├── android/            # Android 플랫폼 코드
├── ios/                # iOS 플랫폼 코드
├── lib/                # 주요 소스코드 (UI, Tmap 연동 등)
├── linux/              # Linux 플랫폼 코드
├── macos/              # macOS 플랫폼 코드
├── test/               # 테스트 코드
├── web/                # 웹 빌드 관련
├── windows/            # Windows 플랫폼 코드
├── pubspec.yaml        # Flutter 패키지 메타정보
├── pubspec.lock        # 의존성 버전 고정
├── .metadata           # 프로젝트 메타데이터
└── README.md           # 설명 문서 (이 파일)
