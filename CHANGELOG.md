# Changelog

## 1.0.0 (2025-11-23)


### Features

* **api:** implement BerlinClockGet and TimeGet service methods ([7660dfc](https://github.com/jonas59075/BerlinClock/commit/7660dfc1fd2c30a6c9ace368f450f88c78dc69a8))
* **api:** restructure backend to backend/api with cmd/server + docker build ([e308004](https://github.com/jonas59075/BerlinClock/commit/e30800402b0477ce67ec46bbba332534bc6fb15d))
* **backend:** add go.mod root module and fix Dockerfile ([65d0104](https://github.com/jonas59075/BerlinClock/commit/65d010424876c690db14076dc97675430d4c7642))
* **ci:** add OpenAPI codegeneration scripts and GitHub Actions workflow ([437373d](https://github.com/jonas59075/BerlinClock/commit/437373d2e0be17b8838d8458570cc21dba9750d2))
* **frontend:** add Elm+Vite build pipeline ([73deb80](https://github.com/jonas59075/BerlinClock/commit/73deb804140a355b791014e8dddcf0c274256bf9))
* **frontend:** add valid Elm entrypoint Main.elm to fix build ([46dfd89](https://github.com/jonas59075/BerlinClock/commit/46dfd89a8723cc10dcc38a427553ab3ca7d28296))
* **spec:** add OpenAPI specification and UI specification ([1607256](https://github.com/jonas59075/BerlinClock/commit/160725689f5fca9e182adaeb4881aa6d306b0c9e))


### Bug Fixes

* add Api root module for Elm namespace consistency ([8c4b92c](https://github.com/jonas59075/BerlinClock/commit/8c4b92c5f7fbbe30fcf52acd937239fa63e86455))
* **api:** regenerate OpenAPI server and add cmd/server entrypoint ([ee3d71a](https://github.com/jonas59075/BerlinClock/commit/ee3d71a571756266930abe0666e7eab580b6893a))
* backend build context and correct Dockerfile ([269fce8](https://github.com/jonas59075/BerlinClock/commit/269fce8d4932196e69b7d3a9c0080986532f3585))
* **backend:** add missing generated API files for SDD stability ([c1b4b55](https://github.com/jonas59075/BerlinClock/commit/c1b4b5596450278370a4c7f181c2ef47c4c1bef5))
* **backend:** add missing go.sum and tidy modules for CI ([76b6631](https://github.com/jonas59075/BerlinClock/commit/76b6631a8515f0d2c9ed04d46cc9f9c60ad5643c))
* **backend:** align BerlinClockState and TimeResponse DTOs ([1dbe476](https://github.com/jonas59075/BerlinClock/commit/1dbe476e9f9448d2e29561c36cc759da786fac9f))
* **backend:** correct build context and compile server ([8da395a](https://github.com/jonas59075/BerlinClock/commit/8da395a691a796f9886caaa8b03b2dfb0091dc23))
* **ci/codex:** update generate_backend_code to new OpenAI responses API format ([d7b9cd9](https://github.com/jonas59075/BerlinClock/commit/d7b9cd9f945ad3a1d09c1d3dcec9cdb9c86aa1b6))
* **ci/codex:** update generate_backend_code to new OpenAI responses API format ([a0693f3](https://github.com/jonas59075/BerlinClock/commit/a0693f39429c0ea337169f7fd8b030d2a7909e1e))
* **ci:** correct working directory for go mod tidy and tests ([e5b25c4](https://github.com/jonas59075/BerlinClock/commit/e5b25c4056a0bce3c02a0afbd0493d0c0d0cf4ce))
* **ci:** correct working directory for go mod tidy and tests ([7572da2](https://github.com/jonas59075/BerlinClock/commit/7572da299a23f551ea094a47c74e0cf126b7a134))
* **ci:** correct working directory for go mod tidy and tests ([a62fdbc](https://github.com/jonas59075/BerlinClock/commit/a62fdbc1b1060fe2dbfae24ebb587b46a3f19aa5))
* **ci:** grant write permissions for PR creation ([91c16f7](https://github.com/jonas59075/BerlinClock/commit/91c16f7ecd16d158bd1d06d19633aa2faf2f4901))
* **ci:** remove interactive Elm installs, rely on committed elm.json ([9e56428](https://github.com/jonas59075/BerlinClock/commit/9e5642856b357bcb144887d398abf8fda6ab18a9))
* **ci:** remove legacy backend/gen/api/go folder ([c8ed966](https://github.com/jonas59075/BerlinClock/commit/c8ed966dbaf6ee14cbf882b78386ec18027f2218))
* **ci:** run go build and tests from backend/gen/api module ([6fd6c18](https://github.com/jonas59075/BerlinClock/commit/6fd6c18e21c7d21c514386bf104ebc51a0ae1068))
* **ci:** vendor Elm packages to avoid GitHub 503 errors ([2363f84](https://github.com/jonas59075/BerlinClock/commit/2363f8442af2b4e85d80675920facecb13141106))
* cleanup macOS junk and update .gitignore ([ee7f6b3](https://github.com/jonas59075/BerlinClock/commit/ee7f6b3200d22ecd37ce0e6e0b04678b67922040))
* **codegen:** make Elm module rename CI-compatible (Linux/macOS safe) ([7f6b0cd](https://github.com/jonas59075/BerlinClock/commit/7f6b0cda4cd3d8951434c38ca1e7d156b9308888))
* **codegen:** sync backend README with CI generator output ([79ec97e](https://github.com/jonas59075/BerlinClock/commit/79ec97e3cd67d7d856f6f425e6bfaf5b1f7e02d8))
* **codegen:** sync backend README.md with CI generator output ([72527d1](https://github.com/jonas59075/BerlinClock/commit/72527d14dabdb33ecbd4d3d127cf14bd19a664cc))
* **codex:** update OpenAI SDK call for new ChatCompletionMessage API ([c7b64d2](https://github.com/jonas59075/BerlinClock/commit/c7b64d28df5fbf0ac7a3b79c95c237109b631bc6))
* **codex:** update OpenAI SDK call for new ChatCompletionMessage API ([b9c5e83](https://github.com/jonas59075/BerlinClock/commit/b9c5e83263a81f7dc9fd22d6425eafc0875f4b3f))
* enable Elm offline mode for Codex/CI builds ([e376654](https://github.com/jonas59075/BerlinClock/commit/e3766548894221826da7f4ebb39c9a056d695934))
* **frontend:** apply SDD cleanup for Elm API client and dependencies ([45bc171](https://github.com/jonas59075/BerlinClock/commit/45bc1713b3a8df43e10fd96cabb2f0f3fd040f8f))
* **go.mod:** replace OpenAPI placeholder module name ([7b9246e](https://github.com/jonas59075/BerlinClock/commit/7b9246e8865f5539f00eafdc0e29900ca392b613))
* **go:** remove OpenAPI placeholder import GIT_USER_ID/GIT_REPO_ID ([39df6d8](https://github.com/jonas59075/BerlinClock/commit/39df6d8b7711cffb97b48ba812d02954eb76f3ca))
* **import:** correct OpenAPI server package path ([2bca0d3](https://github.com/jonas59075/BerlinClock/commit/2bca0d3e54e301cbb0e55fd44f66914e4e754519))
* remove cross-workflow needs dependencies ([c60c173](https://github.com/jonas59075/BerlinClock/commit/c60c173390577fcbd4d1bf491bb2f374df9d73d8))
* **sdd:** fully ignore .openapi-generator folder for stable deterministic codegen ([4c2b78a](https://github.com/jonas59075/BerlinClock/commit/4c2b78a0e4be2b6087f49e122e3bb5afc3e1826c))
* **sdd:** ignore OpenAPI generator metadata for stable codegen ([171bc16](https://github.com/jonas59075/BerlinClock/commit/171bc16805b8defb466be5bedfd2e0f7da16a020))
* **sdd:** remove generated backend README from versioning and ignore in codegen ([7bae67e](https://github.com/jonas59075/BerlinClock/commit/7bae67e995596b30e9a6bed113e48e68f1df6ecd))
