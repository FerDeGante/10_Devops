# Etapa 1: Construcción de la aplicación
FROM node:22.8.0 AS build

WORKDIR /app

ARG REACT_APP_BASE_URL

COPY package.json package-lock.json ./
COPY tsconfig.json ./

RUN npm install

COPY . .

#Validar variable de entorno
ENV REACT_APP_BASE_URL=$REACT_APP_BASE_URL

RUN echo "REACT_APP_BASE_URL=$REACT_APP_BASE_URL" > .env
RUN npm run build

# Etapa 2: Configuración de Nginx
FROM nginx:alpine

# Copiar los archivos construidos
COPY --from=build /app/build /usr/share/nginx/html

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto
EXPOSE 5010

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
