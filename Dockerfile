# ---------- Build stage ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace

COPY gradlew .
COPY gradle gradle
COPY build.gradle* settings.gradle* ./
RUN ./gradlew --no-daemon -v

COPY src src
RUN ./gradlew --no-daemon clean bootJar

# ---------- Runtime stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# non-root user
RUN useradd -r -u 10001 appuser
USER appuser

COPY --from=build /workspace/build/libs/*.jar app.jar

EXPOSE 8080
ENV PORT=8080

# JVM options (tối giản, prod-friendly)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75 -XX:+UseG1GC"

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
