FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8083
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["apiDotnet.csproj", "./"]
RUN dotnet restore "apiDotnet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "apiDotnet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "apiDotnet.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "apiDotnet.dll"]
