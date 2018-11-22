FROM ruby
RUN apt-get update
# RUN apt-get install -y
RUN gem install jekyll bundler

COPY . /build/

ARG GITHUB_TOKEN
# RUN git clone https://250927f9fca220e2916ea366de058b099041b957:x-oauth-basic@github.com/chpmnrssll/demo-content.git
RUN git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/chpmnrssll/demo-content.git /demo-content/
WORKDIR /demo-content/
RUN cp -rf * /build/

WORKDIR /build/
RUN bundle install
RUN bundle exec jekyll build

RUN git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/chpmnrssll/static-output.git /static-output/
WORKDIR /static-output/
RUN rm -rf *.*
RUN cp -rf /build/_site/* /static-output/
RUN git config --global user.email "chpmnrssll@gmail.com" && git config --global user.name "Russell Chapman"
RUN git add . && git commit -m "Jekyll build from Docker"
RUN git push

# WORKDIR /build/_site/
# RUN git remote add origin https://${GITHUB_TOKEN}:x-oauth-basic@github.com/chpmnrssll/static-output.git
# RUN git push origin master
