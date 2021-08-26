# syntax=docker/dockerfile:1
FROM ruby:2.6.3

RUN mkdir /todo_app

WORKDIR /todo_app

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y \
    nodejs \
    yarn \
    mariadb-client \
    gcc \
    pkg-config \
    libmagickwand-dev
COPY Gemfile /todo_app/Gemfile
COPY Gemfile.lock /todo_app/Gemfile.lock
RUN bundle install \
    && yarn install --check-files
COPY . /todo_app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]