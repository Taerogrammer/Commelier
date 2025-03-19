# CrypMulator

### 가상 화폐에 관심있다면? CrypMulator를 통해 가상 화폐에 대한 실시간 정보를 확인해보세요!

CrypMulator는 코인과 NFT 등의 정보를 실시간으로 조회하고, 관심 목록을 관리할 수 있는 iOS 앱입니다.

<br><br><br>

# 주요 기능

### ✅ 실시간 조회

- 가상 화폐에 대한 정보를 실시간으로 확인할 수 있습니다.
- 가격이 상승하면 🔺, 하락하면 🔻 아이콘 등을 통해 직관적으로 이해할 수 있도록 하였습니다.
- 24시간 거래량, 최고/최저가 등 추가 정보를 제공해줍니다.


<br>

### ✅ 즐겨찾기 기능

관심있는 가상 화폐 목록을 관리할 수 있습니다.

<br><br><br>

# 개발 기간 및 팀 구성

- 개발 기간 2025.03.06 ~ 2025.03.11 (6일)
- 개발 인원: 1명

<br><br><br>

# 기술 스택

- 언어: Swift
- UI 프레임워크: UIKit Code base 
- 아키텍쳐: MVVM
- 비동기 처리: RxSwift, RxCocoa
- 데이터베이스: Realm
- 라이브러리 및 프레임워크: Alamofire / Kingfisher / Snapkit / Toast / RxDataSources

<br><br><br>

# 기술 설명

## 아키텍쳐 - MVVM InOut 패턴

MVVM(Model-View-ViewModel)은 ```UI 로직과 비즈니스 로직을 분리하여 유지보수성과 확장성을 높이는 디자인 패턴```으로, 데이터 바인딩을 통해 UI 변화를 효율적으로 관리할 수 있습니다.
특히 InOut 패턴을 적용하여 입력(Input)과 출력(Output)을 명확하게 정의하고, RxSwift를 활용하여 비동기 데이터 흐름을 관리함으로써 코드의 가독성과 유지 보수성을 높였습니다.

<br>

## 데이터베이스 - Realm

Realm은 모바일용 데이터베이스로, 여러 플랫폼에서 사용이 가능하며, Read/Write 연산에서 높은 성능을 보인다는 특징을 지니고 있습니다. ORM(Object-Relational Mapping)으로 객체를 SQL문이 아닌 프로그래밍 언어를 통해 RDBMS의 테이블과 매핑할 수 있습니다.