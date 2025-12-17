.PHONY: init flutter_pub_get generate_code clean format lint test build

RIVERPOD_GENERATOR_INPUT := $(filter-out %.g.dart,$(wildcard lib/riverpod/*.dart))
RIVERPOD_GENERATOR_OUTPUT := $(patsubst %.dart,%.g.dart,$(RIVERPOD_GENERATOR_INPUT))

init: flutter_pub_get generate_code

flutter_pub_get: .dart_tool/package_config.json

.dart_tool/package_config.json: pubspec.yaml
	flutter pub get
	@touch .dart_tool/package_config.json

generate_code: lib/services/AudioApi.dart lib/drift/database.drift.dart $(RIVERPOD_GENERATOR_OUTPUT)

clean:
	rm -rf .dart_tool \
	       build \
	       android/app/src/main/java/de/michaeltamm/meine_musik/AudioApi.java \
	       lib/drift/database.drift.dart \
	       lib/drift/database.drift.dart \
	       lib/services/AudioApi.dart \
	       lib/riverpod/*.g.dart

format:
	dart format lib/ pigeons/ test/

lint: init
	flutter analyze
	dart run custom_lint

test: init
	flutter test

build: init build/app/outputs/bundle/release/app-release.aab

lib/services/AudioApi.dart android/app/src/main/java/de/michaeltamm/meine_musik/AudioApi.java: pigeons/AudioApi.dart
	dart run pigeon \
	         --input pigeons/AudioApi.dart \
	         --java_out android/app/src/main/java/de/michaeltamm/meine_musik/AudioApi.java \
	         --java_package "de.michaeltamm.meine_musik" \
	         --dart_out lib/services/AudioApi.dart \
	         --package_name meine_musik
	dart format lib/services/AudioApi.dart

lib/drift/database.drift.dart $(RIVERPOD_GENERATOR_OUTPUT) &: build.yaml lib/drift/database.dart $(RIVERPOD_GENERATOR_INPUT)
	dart run build_runner build --delete-conflicting-outputs
	dart format lib/drift/database.drift.dart
	dart format lib/riverpod/*.g.dart

build/app/outputs/bundle/release/app-release.aab: .git/refs/heads/trunk
	$(eval GIT_COMMIT_COUNT := $(shell git rev-list --count HEAD))
	flutter build appbundle --release --no-pub --build-name=0.0.$(GIT_COMMIT_COUNT) --build-number=$(GIT_COMMIT_COUNT) --no-obfuscate
