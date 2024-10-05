# Use the official Ruby image as the base image
FROM ruby:3.2.5

# Set the working directory inside the container
WORKDIR /var/www/

# Install curl and Node.js 18
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Copy package.json and install dependencies
COPY package.json /var/www/
RUN yarn global add esbuild

# Copy Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock /var/www/

# Install the specific version of Bundler
RUN gem install bundler:2.5.20 

# Install gems
RUN bundle install 

# Copy the rest of the application code
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "puma", "config.ru"]
