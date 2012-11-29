Server Status
==========
[![Dependency Status](https://gemnasium.com/astral1/server_status.png)](https://gemnasium.com/astral1/server_status)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/astral1/server_status)

서버의 상태를 체크하고 쉽게 확인하기 위한 도구입니다. 도메인 별로 port 상태와 대표 API의 동작 여부를 확인합니다.

사용법
----
```bash
gem install server_status
statusd run <path to config file>
```
데몬으로 실행하고 싶을 때
```bash
gem install server_status
statusd start <path to config file>
```
데몬을 멈추고 싶을 때
```bash
gem install server_status
statusd stop <path to config file>
```
현재는 start와 stop을 동일한 work directory에서만 실행하여야 함.

API
---
- **/servers** - 확인 대상의 목록
```
["google","test"]
```
- **/:server_name/status - 해당 대상의 상태
```
{"name":"google","code":404,"description":"Google Portal","is_open":true}
```

예제 설정
----
```yaml
port: 4568
refresh: 3000
servers:
  google:
    protocol: http
    domain: www.google.com
    ssl: false
    description: Google Portal
    port: 80
    apis:
      default:
        url: /deaddead
      details:
        index:
          description: Index Page
          url: /
  test:
    protocol: http
    domain: localhost
    ssl: false
    description: Test Dummy
    port: 4567
    apis:
      default:
        url: /
        payload:
          header:
            content_type: application/json
          params:
            query: TEST
          encode: json
          method: get
```

Copyright
---------

이 프로젝트는 Simplified BSD 2.0 라이센스로 제공되고 있습니다.

Copyright (c) 2012 Jeong, Jiung. See LICENSE.txt for
further details.

