build:
	elm make src/CVPage/Main.elm --output=cv-index.js
	elm make src/MBus/Wired/Main.elm --output=wired-mbus-decoder.js
	elm make src/CVPage2/Main.elm --output=cv-index2.js

css:
	npx @tailwindcss/cli -i input.css -o output.css --watch --minify --optimize

webserver:build
	python3 -m http.server

BIN := ./node_modules/uglify-js/bin/uglifyjs
UGLIFY_ARGS := "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe"
build_prod:
	elm make src/CVPage/Main.elm --output=cv-index.js --optimize
	elm make src/CVPage2/Main.elm --output=cv-index2.js --optimize

	elm make src/MBus/Wired/Main.elm --output=wired-mbus-decoder.js --optimize
	$(BIN) cv-index.js --compress $(UGLIFY_ARGS) | $(BIN) --mangle --output cv-index.min.js
	$(BIN) cv-index2.js --compress $(UGLIFY_ARGS) | $(BIN) --mangle --output cv-index2.min.js
	$(BIN) wired-mbus-decoder.js --compress $(UGLIFY_ARGS) | $(BIN) --mangle --output wired-mbus-decoder.min.js
