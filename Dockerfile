# Use Node.js base image
FROM node:18

RUN apt-get update \
    && apt-get install default-jre -y \
    && apt-get install default-jdk -y \
    && apt-get install watchman -y

# Set working directory
WORKDIR /usr/src/app

# Install necessary dependencies
COPY package*.json ./
RUN npm install

# Expose the necessary ports for the emulator
COPY ./serverless.yml ./serverless.yml

# Serverless Port
EXPOSE 3000
# DynamoDB Port
EXPOSE 8000
# AppSync Port
EXPOSE 20002

# Install serverless and appsync-emulator-serverless
RUN npm install -g serverless serverless-dynamodb serverless-appsync-plugin serverless-appsync-simulator serverless-offline

RUN npm install cfn-resolver-lib@1.1.7

RUN npm install watchman

# ENV SERVERLESS_ACCESS_KEY=AKHhDJUInwTZwBCLuGncvL6BqAVXWjnDQ6atY0OsGs5RC
# RUN serverless plugin install --name serverless-dynamodb
# RUN serverless dynamodb install

# CMD ["serverless", "offline", "start", "--reloadHandler"]
CMD tail -f /dev/null

# ENTRYPOINT ["serverless"]