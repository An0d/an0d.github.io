docker run --rm --volume="%cd%:/srv/jekyll" --volume="jekyll-vendor-bundle:/usr/local/bundle" -it -p 4000:4000 --env JEKYLL_ENV=development jekyll/jekyll:4.0 jekyll serve --force_polling --livereload