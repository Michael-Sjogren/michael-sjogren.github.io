build:
	elm make src/Main.elm --output=index.js

css:
	npx @tailwindcss/cli -i input.css -o output.css --watch --minify --optimize

webserver:build
	python3 -m http.server
