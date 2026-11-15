build:
	elm make src/CVPage/Main.elm --output=cv-index.js
	elm make src/MBus/Wired/Main.elm --output=wired-mbus-decoder.js

css:
	npx @tailwindcss/cli -i input.css -o output.css --watch --minify --optimize

webserver:build
	python3 -m http.server

BIN := ./node_modules/uglify-js/bin/uglifyjs
build_prod:
	elm make src/CVPage/Main.elm --output=cv-index.js --optimize
	elm make src/MBus/Wired/Main.elm --output=wired-mbus-decoder.js --optimize
	$(BIN) cv-index.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | $(BIN) --mangle --output cv-index.min.js
	$(BIN) wired-mbus-decoder.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | $(BIN) --mangle --output wired-mbus-decoder.min.js
