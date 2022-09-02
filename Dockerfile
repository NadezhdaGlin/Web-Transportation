FROM ruby:3.0.3

RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /myapp
COPY . /myapp

RUN bundle check || bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000