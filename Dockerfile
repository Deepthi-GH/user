FROM node:20.19.5-alpine3.21 AS build 
WORKDIR /opt/server    
COPY package.json .
COPY *.js .
# this may add extra cache memory
RUN npm install 

# this is the final image. after copying it deletes above image
FROM node:20.19.5-alpine3.21
WORKDIR /opt/server 
# Create a group and user
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
    chown -R roboshop:roboshop /opt/server
EXPOSE 8080
LABEL com.project="roboshop" \
      component="user" \
      created_by="deepthi"
ENV MONGO="TRUE" \
    REDIS_URL="redis://redis:6379" \
    MONGO_URL="mongodb://mongodb:27017/users"
# to start the container   
# it copies the files with roboshop user
COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server
USER roboshop
CMD [ "server.js"]
ENTRYPOINT ["node"] 