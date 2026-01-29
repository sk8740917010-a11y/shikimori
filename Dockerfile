FROM ruby:3.2

RUN apt-get update -qq && \
    apt-get install -y curl build-essential libpq-dev

# Install Node 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

WORKDIR /app
COPY . /app

RUN gem install bundler -v 2.4.22
RUN bundle _2.4.22_ install
RUN yarn install

EXPOSE 3000
