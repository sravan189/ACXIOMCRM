FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/AcxiomCRM.Core/AcxiomCRM.Core.csproj", "src/AcxiomCRM.Core/"]
COPY ["src/AcxiomCRM.Web/AcxiomCRM.Web.csproj", "src/AcxiomCRM.Web/"]
RUN dotnet restore "src/AcxiomCRM.Web/AcxiomCRM.Web.csproj"
COPY . .
RUN dotnet publish "src/AcxiomCRM.Web/AcxiomCRM.Web.csproj" -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true
EXPOSE 10000
ENTRYPOINT ["sh", "-c", "dotnet AcxiomCRM.Web.dll --urls http://0.0.0.0:${PORT:-10000}"]
