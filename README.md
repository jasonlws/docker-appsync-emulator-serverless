# docker-appsync-emulator-serverless


https://www.serverless.com/plugins/serverless-appsync-simulator

docker build --no-cache -t appsync-simulator .
docker-compose -f .\docker-compose.yml --env-file .\.env up

{
  "name": "appsync-emulator",
  "version": "1.0.0",
  "description": "Local AppSync Emulator with Serverless Framework",
  "dependencies": {
    "aws-sdk": "^2.1692.0",
    "graphql": "^16.10.0",
    "graphql-tools": "^9.0.16",
    "serverless": "^3.40.0",
    "serverless-appsync-plugin": "^2.9.1",
    "serverless-appsync-simulator": "^0.20.0",
    "serverless-dynamodb": "^0.2.56",
    "serverless-offline": "^13.9.0"
  }
}

# Use Node.js base image
FROM node:18-alpine

RUN  apk update \
  && apk upgrade \
  && apk add openjdk11-jre

# Set working directory
WORKDIR /usr/src/app

# Install necessary dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the necessary ports for the emulator

# AppSync Port
EXPOSE 20002

# DynamoDB Port
EXPOSE 8000

# Install serverless and appsync-emulator-serverless
RUN npm install -g serverless serverless-dynamodb serverless-appsync-simulator

ENV SERVERLESS_ACCESS_KEY=AKHhDJUInwTZwBCLuGncvL6BqAVXWjnDQ6atY0OsGs5RC
# RUN serverless plugin install --name serverless-dynamodb
RUN serverless dynamodb install

CMD ["serverless", "offline", "start"]


service: my-appsync-simulator

provider:
  name: aws
  region: us-west-2
  runtime: nodejs18.x

plugins:
  - serverless-dynamodb
  - serverless-appsync-plugin
  - serverless-appsync-simulator
  - serverless-offline

custom:
  serverless-dynamodb:
    start:
      port: 8000
      docker: false

  appsync-simulator:
    apiKey: "my-local-api-key"
    port: 20002

  appSync:
    name: "MyAppSyncAPI"
    authenticationType: "API_KEY"
    apiKeys:
      - my-local-api-key
    mappingTemplatesLocation: "mapping-templates"
    schema: "schema.graphql"
    resolvers:
      Query.getPost:
        dataSource: "PostsTable"
      Mutation.createPost:
        dataSource: "PostsTable"

functions:
  graphql:
    handler: handler.graphqlHandler
    events:
      - http:
          path: graphql
          method: post
          cors: true

resources:
  Resources:
    PostsTable:
      Type: AWS::DynamoDB::Table
      Properties:
        TableName: PostsTable
        AttributeDefinitions:
          - AttributeName: "id"
            AttributeType: "S"
        KeySchema:
          - AttributeName: "id"
            KeyType: "HASH"
        BillingMode: PAY_PER_REQUEST


{
  "name": "appsync-emulator",
  "version": "1.0.0",
  "description": "Local AppSync Emulator with Serverless Framework",
  "dependencies": {
    "cfn-resolver-lib": "^1.1.7",
    "serverless": "^3.40.0",
    "serverless-appsync-plugin": "^2.9.1",
    "serverless-appsync-simulator": "^0.20.0",
    "serverless-dynamodb": "^0.2.56",
    "serverless-offline": "^13.9.0"
  },
  "resolutions": {
    "serverless-appsync-simulator/cfn-resolver-lib": "1.1.7"
  }
}

npm install watchman

 - type: AMAZON_DYNAMODB
        name: dataSourceChild
        description: "Child"
        config:
          tableName: Child

x-api-key

$ctx.args.childId



type Child {
  childId: String!
  name: String
  description: String
}

type ChildList {
  items: [Child]
  nextToken: String
}

type Query {
  getParent(parentId: String!): Parent
  getChild(childId: String!): Child
  listChilds: ChildList
}

input AddChild {
  childId: String!
  name: String
  description: String
}

type Mutation {
  addChild(input: AddChild!): Child
}

type Parent {
  parentId: String!
  name: String
  description: String
  children: [Child]
}

