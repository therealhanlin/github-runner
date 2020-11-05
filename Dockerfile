FROM ubuntu:latest

# Create user
RUN useradd -m actions

# Update and install pkgs
RUN apt-get -yqq update && apt-get install -yqq curl jq wget

# Download latest runner
WORKDIR /home/actions
RUN \
  TAG_NAME=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.name') \
  && RUNNER_VERSION=${TAG_NAME##v} \
  && mkdir actions-runner && cd actions-runner \
  && wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install dependencies
WORKDIR /home/actions/actions-runner
COPY entrypoint.sh .
RUN chown -R actions ~actions && /home/actions/actions-runner/bin/installdependencies.sh

# Change user
USER actions
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]