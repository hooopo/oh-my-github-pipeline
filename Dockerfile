# Use an Ubuntu-based Ruby image
FROM ruby:3.2

# Set the working directory
WORKDIR /

# Install MySQL client and development libraries
RUN apt-get update -qq && \
    apt-get install -y default-mysql-client default-libmysqlclient-dev ca-certificates

# Set argument variables
ARG DATABASE_URL
ARG ACCESS_TOKEN
ARG USER_LOGIN
ARG OPENAI_TOKEN


# Set environment variables
ENV DATABASE_URL=$DATABASE_URL
ENV ACCESS_TOKEN=$ACCESS_TOKEN
ENV USER_LOGIN=$USER_LOGIN
ENV OPENAI_TOKEN=$OPENAI_TOKEN

# Copy the Gemfile and Gemfile.lock
COPY . .

# Install dependencies
RUN bundle config set --local without 'development test' && \
    bundle install --jobs $(nproc) --retry 10 && \
    rm -rf /usr/local/bundle/cache/*.gem

# Run the migration and sync GitHub Repo Data scripts
CMD ls && pwd && bundle exec rails runner "RetryableRake.db_create" && \
    bundle exec rails runner "RetryableRake.db_migrate" && \
    bundle exec rails runner "SyncGithub.run!"
