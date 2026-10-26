# Local preview environment matching the GitHub Actions build (Ruby 4.0).
FROM ruby:4.0-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential git \
 && rm -rf /var/lib/apt/lists/*

# Install gems from a copy of the Gemfile kept inside the image, so Bundler can
# add this machine's platform (e.g. aarch64-linux on Apple Silicon) without
# rewriting the repo's Gemfile.lock.
WORKDIR /gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 4.0.22 \
 && bundle install
ENV BUNDLE_GEMFILE=/gems/Gemfile

WORKDIR /site
EXPOSE 4000 35729
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload", "--force_polling", "--disable-disk-cache", "--destination", "/tmp/_site"]
