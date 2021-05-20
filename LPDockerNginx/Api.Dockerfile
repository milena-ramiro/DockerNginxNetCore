FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["LPDockerNginx.csproj", "./"]
RUN dotnet restore "./LPDockerNginx.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "LPDockerNginx.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LPDockerNginx.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "LPDockerNginx.dll"]

# docker build -t hello-aspnetcore3 -f Api.Dockerfile .
# docker run -d -p 5000:5000 --name hello-aspnetcore3  hello-aspnetcore3
