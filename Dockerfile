# Koristimo zvanični Node.js Docker image kao osnovu
FROM node:18 AS build

# Postavljanje radnog direktorijuma unutar kontejnera
WORKDIR /app

# Kopiranje paketa za zavisnosti i konfiguracionih datoteka
COPY package*.json ./

# Instalacija zavisnosti
RUN npm install

# Kopiranje celog Angular projekta u kontejner
COPY . .

# Izgradnja Angular aplikacije
RUN npm run build --prod

# Koristimo nginx Docker image kao osnovu za finalni kontejner
FROM nginx:alpine

# Kopiranje izgrađene Angular aplikacije iz prethodnog stage-a u nginx direktorijum za hosting
COPY --from=build /app/dist /usr/share/nginx/html

# Konfiguracija nginx da služi Angular aplikaciju
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
