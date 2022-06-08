FROM docker:stable

ENV GITHUB_TEST True

COPY ./scripts /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
