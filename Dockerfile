# Use the official Ruby image as the base image
FROM ruby:3.0.0
RUN mkdir -p /var/www/memee-app
# Set the working directory in the container
WORKDIR /var/www/memee-app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install project dependencies
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose the port the Rails app runs on
EXPOSE 3000

# Start the Rails server & sidekiq
CMD ["bash", "-c", "bin/rails server -e production && bundle exec sidekiq -e production"]

