build:
	elm make src/CVPage/Main.elm --output=cv-index.js
	elm make src/MBus/Wired/Main.elm --output=wired-mbus-decoder.js

css:
	npx @tailwindcss/cli -i input.css -o output.css --watch --minify --optimize

webserver:build
	python3 -m http.server
